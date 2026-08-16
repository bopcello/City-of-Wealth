# Preserve WorkDatabase and its constructors for WorkManager reflection
-keep class androidx.work.impl.WorkDatabase { *; }
-keep class androidx.work.impl.WorkDatabase_Impl { public <init>(...); }
-keep class androidx.work.impl.model.** { *; }
-keep class androidx.work.impl.background.systemjob.SystemJobService { *; }

# General WorkManager rules
-keep class androidx.work.** { *; }
-dontwarn androidx.work.**
