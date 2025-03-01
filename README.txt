This is a rethinking of the flasher script by the 13DEVTEAM that was 99% executed by Jonas and tested by docnok63.  The goal was to have one script to flash either a super.img build (typically for CN users) or a mostly fastbootd partitions flasher for non-CN owners.  This new part is based on the revive_13 script by Venkat, so BIG shoutout to him.  There were other minor text output error fixed.

The simplest way to explain this:

1) More partitions are flashed in fastboot now to stop bootlooping from not having proper recovery/fastbootd. Super.img is then flashed right after that if in the build.  Phone is then booted into fastbootd.

2) If super.img was already flashed, the script does not flash them again in fastbootd.  If super.img is not present, then all of its contents are flashed now.  Both with and without super.img also get about a dozen other partitions.

3) If super.img was in the build, it asks users if they want to root and wipe as our previous script. 

Root actions:
a) If you choose to root, no files are flashed as signal will be fixed by @flymetothehorizon's module after rooting.
b) If you choose not to root, my_region from Oppo Find X8 Pro and oplusstanvbk from COS401 are flashed

Wipe action
a) If you choose not to wipe, the phone will be rebooted into Android
b) If you choose to wipe, the script will end telling you how to format data in fastbootd

4) The phone will NEVER be automatically rebooted by the script, there is always a pause for you to check for flashing errors, so PLEASE do so.

5) There are two files in OOS_FILES_HERE.  DO NOT remove them or you will boot into black screen after flashing.

6) There are two files in COS_FILES_HERE.  DO NOT remove them.  They are if you learn how to make a super.img and get flashed if you say no to root.

7) PLEASE CHECK FOR FLASHING ERRORS.  DO NOT BOOT INTO SYSTEM IF YOU HAVE ANY.
 
Happy flashing,
Doc and Jonas