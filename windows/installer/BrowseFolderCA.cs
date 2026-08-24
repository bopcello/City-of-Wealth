using System;
using System.IO;
using System.Runtime.InteropServices;
using System.Threading;
using System.Windows.Forms;
using Microsoft.Deployment.WindowsInstaller;

namespace CityOfWealthInstaller
{
    public class CustomActions
    {
        [DllImport("user32.dll", SetLastError = true)]
        static extern bool SetThreadDpiAwarenessContext(IntPtr dpiContext);

        [DllImport("user32.dll", SetLastError = true)]
        static extern bool SetProcessDPIAware();

        static readonly IntPtr DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2 = new IntPtr(-4);
        static readonly IntPtr DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE = new IntPtr(-3);

        [ComImport]
        [Guid("D57C7288-D4AD-4768-BE02-9D969532D960")]
        [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
        interface IFileOpenDialog
        {
            [PreserveSig] int Show([In] IntPtr parent);
            void SetFileTypes(uint cFileTypes, IntPtr rgFilterSpec);
            void SetFileTypeIndex(uint iFileType);
            void GetFileTypeIndex(out uint piFileType);
            void Advise(IntPtr pfde, out uint pdwCookie);
            void Unadvise(uint dwCookie);
            void SetOptions([In] uint dwOptions);
            void GetOptions(out uint pdwOptions);
            void SetDefaultFolder([In, MarshalAs(UnmanagedType.Interface)] IShellItem psi);
            void SetFolder([In, MarshalAs(UnmanagedType.Interface)] IShellItem psi);
            void GetFolder([MarshalAs(UnmanagedType.Interface)] out IShellItem ppsi);
            void GetCurrentSelection([MarshalAs(UnmanagedType.Interface)] out IShellItem ppsi);
            void SetFileName([In, MarshalAs(UnmanagedType.LPWStr)] string pszName);
            void GetFileName([MarshalAs(UnmanagedType.LPWStr)] out string pszName);
            void SetTitle([In, MarshalAs(UnmanagedType.LPWStr)] string pszTitle);
            void SetOkButtonLabel([In, MarshalAs(UnmanagedType.LPWStr)] string pszText);
            void SetFileNameLabel([In, MarshalAs(UnmanagedType.LPWStr)] string pszLabel);
            void GetResult([MarshalAs(UnmanagedType.Interface)] out IShellItem ppsi);
            void AddPlace([In, MarshalAs(UnmanagedType.Interface)] IShellItem psi, uint fdap);
            void SetDefaultExtension([In, MarshalAs(UnmanagedType.LPWStr)] string pszDefaultExtension);
            void Close([MarshalAs(UnmanagedType.Error)] int hr);
            void SetClientGuid([In] ref Guid guid);
            void ClearClientData();
            void SetFilter([In, MarshalAs(UnmanagedType.Interface)] object pFilter);
        }

        [ComImport]
        [Guid("43826D1E-E718-42EE-BC55-A1E261C37BFE")]
        [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
        interface IShellItem
        {
            void BindToHandler(IntPtr pbc, [In] ref Guid bhid, [In] ref Guid riid, out IntPtr ppv);
            void GetParent([MarshalAs(UnmanagedType.Interface)] out IShellItem ppsi);
            void GetDisplayName([In] uint sigdnName, [MarshalAs(UnmanagedType.LPWStr)] out string ppszName);
            void GetAttributes([In] uint sfgaoMask, out uint psfgaoAttribs);
            void Compare([In, MarshalAs(UnmanagedType.Interface)] IShellItem psi, [In] uint hint, out int piOrder);
        }

        [ComImport]
        [Guid("DC1C5A9C-E88A-4dde-A5A1-60F82A20AEF7")]
        class FileOpenDialogRC {}

        [DllImport("shell32.dll", CharSet = CharSet.Unicode, PreserveSig = false)]
        static extern void SHCreateItemFromParsingName(
            [In, MarshalAs(UnmanagedType.LPWStr)] string pszPath,
            IntPtr pbc,
            [In] ref Guid riid,
            [MarshalAs(UnmanagedType.Interface)] out IShellItem ppv);

        [CustomAction]
        public static ActionResult BrowseForFolder(Session session)
        {
            session.Log("BrowseForFolder Custom Action starting...");
            string selectedPath = null;

            var thread = new Thread(() =>
            {
                // Enable Per-Monitor V2 DPI awareness so dialog is crisp and not blurred by Windows scaling
                try
                {
                    if (!SetThreadDpiAwarenessContext(DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2))
                    {
                        SetThreadDpiAwarenessContext(DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE);
                    }
                }
                catch
                {
                    try { SetProcessDPIAware(); } catch { }
                }

                try
                {
                    var dialog = (IFileOpenDialog)new FileOpenDialogRC();
                    uint FOS_PICKFOLDERS = 0x20;
                    uint FOS_FORCEFILESYSTEM = 0x40;
                    dialog.SetOptions(FOS_PICKFOLDERS | FOS_FORCEFILESYSTEM);
                    dialog.SetTitle("Select the folder to install City of Wealth");

                    string currentProp = session["WIXUI_INSTALLDIR"];
                    if (string.IsNullOrEmpty(currentProp)) currentProp = "INSTALLFOLDER";
                    string current = session[currentProp];

                    if (!string.IsNullOrEmpty(current) && Directory.Exists(current))
                    {
                        try
                        {
                            Guid guidShellItem = new Guid("43826D1E-E718-42EE-BC55-A1E261C37BFE");
                            IShellItem initialFolder;
                            SHCreateItemFromParsingName(current, IntPtr.Zero, ref guidShellItem, out initialFolder);
                            if (initialFolder != null)
                            {
                                dialog.SetFolder(initialFolder);
                            }
                        }
                        catch { }
                    }

                    int hr = dialog.Show(IntPtr.Zero);
                    if (hr == 0)
                    {
                        IShellItem item;
                        dialog.GetResult(out item);
                        string path;
                        item.GetDisplayName(0x80058000, out path); // SIGDN_FILESYSPATH
                        selectedPath = path;
                    }
                }
                catch (Exception ex)
                {
                    session.Log("IFileOpenDialog failed, falling back to FolderBrowserDialog: " + ex.Message);
                    using (var dialog = new FolderBrowserDialog())
                    {
                        dialog.Description = "Select the folder to install City of Wealth";
                        string currentProp = session["WIXUI_INSTALLDIR"];
                        if (string.IsNullOrEmpty(currentProp)) currentProp = "INSTALLFOLDER";
                        string current = session[currentProp];
                        if (!string.IsNullOrEmpty(current) && Directory.Exists(current))
                            dialog.SelectedPath = current;

                        if (dialog.ShowDialog() == DialogResult.OK)
                            selectedPath = dialog.SelectedPath;
                    }
                }
            });
            thread.SetApartmentState(ApartmentState.STA);
            thread.Start();
            thread.Join();

            if (!string.IsNullOrEmpty(selectedPath))
            {
                if (!selectedPath.EndsWith("\\")) selectedPath += "\\";

                string targetDirProp = session["WIXUI_INSTALLDIR"];
                if (string.IsNullOrEmpty(targetDirProp)) targetDirProp = "INSTALLFOLDER";

                session[targetDirProp] = selectedPath;
                session.Log("BrowseForFolder selected path: " + selectedPath);
            }
            return ActionResult.Success;
        }
    }
}
