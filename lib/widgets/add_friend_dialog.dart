import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/friends_service.dart';
import '../models/city_sharing_models.dart';
import '../theme/app_colors.dart';

class AddFriendDialog extends StatefulWidget {
  final String myFriendCode;
  final List<Friendship> currentFriendships;

  const AddFriendDialog({
    super.key,
    required this.myFriendCode,
    required this.currentFriendships,
  });

  @override
  State<AddFriendDialog> createState() => _AddFriendDialogState();
}

class _AddFriendDialogState extends State<AddFriendDialog> {
  final TextEditingController _searchController = TextEditingController();
  final FriendsService _friendsService = FriendsService();
  
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;
  String? _errorMessage;

  void _search() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _searchResults = [];
    });

    try {
      final results = await _friendsService.searchUsers(query);
      setState(() {
        _searchResults = results.where((user) => user['uid'] != _friendsService.currentUid).toList();
        if (_searchResults.isEmpty) {
          _errorMessage = "No users found matching '$query'";
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Error searching users: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _sendRequest(String targetUid) async {
    try {
      await _friendsService.sendRequest(targetUid);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Friend request sent successfully!"),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to send request: $e"),
          backgroundColor: AppColors.of(context, 'error'),
        ),
      );
    }
  }

  void _unblockUser(String friendshipId) async {
    try {
      await _friendsService.unblockFriend(friendshipId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User unblocked."),
          duration: Duration(seconds: 2),
        ),
      );
      // Refresh results so the button updates to "Add"
      _search();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to unblock: $e"),
          backgroundColor: AppColors.of(context, 'error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Map of friendship status by user ID
    final Map<String, Friendship> friendMap = {};
    for (var f in widget.currentFriendships) {
      final otherUid = f.playerA == _friendsService.currentUid ? f.playerB : f.playerA;
      friendMap[otherUid] = f;
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Add Friend",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Show current user friend code
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.qr_code, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "My Friend Code: ${widget.myFriendCode}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: widget.myFriendCode));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Friend code copied!"),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy, size: 16),
                    label: const Text("Copy"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Search input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: "Enter Friend Code or Name",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _search,
                  child: const Text("Search"),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Results / Loading / Errors
            if (_isLoading)
              const Center(child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ))
            else if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: AppColors.of(context, 'error')),
                  textAlign: TextAlign.center,
                ),
              )
            else if (_searchResults.isNotEmpty)
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 250),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final user = _searchResults[index];
                    final userUid = user['uid'] as String;
                    final username = user['playerName'] as String? ?? 'User';
                    final userCode = user['friendCode'] as String? ?? '';
                    
                    final friendship = friendMap[userUid];
                    Widget actionButton;

                    if (friendship == null) {
                      actionButton = ElevatedButton(
                        onPressed: () => _sendRequest(userUid),
                        child: const Text("Add"),
                      );
                    } else if (friendship.status == 'pending') {
                      final wasRequestedByMe = friendship.requestedBy == _friendsService.currentUid;
                      actionButton = Text(
                        wasRequestedByMe ? "Requested" : "Incoming",
                        style: const TextStyle(color: Colors.grey),
                      );
                    } else if (friendship.status == 'accepted') {
                      actionButton = const Icon(Icons.check, color: Colors.green);
                    } else if (friendship.status == 'blocked') {
                      // Only show Unblock if the current user was the one who blocked
                      final iBlockedThem = friendship.requestedBy == _friendsService.currentUid;
                      if (iBlockedThem) {
                        actionButton = OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                          onPressed: () => _unblockUser(friendship.id),
                          child: const Text("Unblock"),
                        );
                      } else {
                        actionButton = const Text("Blocked", style: TextStyle(color: Colors.grey));
                      }
                    } else {
                      actionButton = const SizedBox.shrink();
                    }


                    return ListTile(
                      title: Text(username),
                      subtitle: Text("Code: $userCode"),
                      trailing: actionButton,
                    );
                  },

                ),
              ),
          ],
        ),
      ),
    );
  }
}
