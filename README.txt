This is a rethinking of the flasher script by the 13DEVTEAM that was 99% executed by Jonas and tested by docnok63.  The goal was to have one script to flash either a super.img build (typically for CN users) or a mostly fastbootd partitions flasher for non-CN owners.  This new part is based on the revive_13 script by Venkat, so BIG shoutout to him.  There were other minor text output error fixed.

This explanation is clear and well-structured, but I can refine it for better readability and clarity:  

---

 **Updated Flashing Guide**  

 **1) Initial Fastboot Flashing**  
- More partitions are now flashed in fastboot to prevent bootloops caused by missing recovery/fastbootd.  
- If the build includes a `super.img`, it is flashed immediately after.  
- The phone then boots into fastbootd.  

 **2) Flashing in Fastbootd**  
- If `super.img` was already flashed earlier, it will NOT be flashed again in fastbootd.  
- If `super.img` was NOT present in the build, its contents will now be flashed individually.  
- Regardless of whether `super.img` was included, about a dozen other partitions are also flashed.  

 **3) Root and Wipe Options**  
If `super.img` was included in the build, you will be prompted to choose:  

 **Root Options**  
- **Rooting**: No additional files are flashed, as @flymetothehorizon's module will fix signal issues after rooting.  
- **Not Rooting**:  
  - `my_region` (from Oppo Find X8 Pro)  
  - `oplusstanvbk` (from COS401)  
  - These files are flashed to ensure functionality.  

 **Wipe Options**  
- **No Wipe**: The phone will reboot into Android.  
- **Wipe**: The script will end with instructions on how to format data in fastbootd.  

 **4) Manual Error Checking Before Rebooting**  
- The script **NEVER** automatically reboots the phone.  
- There is always a pause for you to check for any flashing errors—**DO NOT SKIP THIS STEP**.  

 **5) Important Files – Do NOT Delete!**  
- **`OOS_FILES_HERE` folder**: Contains two essential files. Deleting them will cause a black screen on boot.  
- **`COS_FILES_HERE` folder**: Also contains two critical files. These are required if you manually create a `super.img` and are used when choosing **not** to root.  

 **6) Final Reminder – CHECK FOR FLASHING ERRORS!**  
- **DO NOT boot into the system if any errors occur**—this can lead to serious issues.  

**Happy flashing!**  
*— Doc & Jonas*  

---

This keeps the instructions clear while making them easier to follow. Let me know if you'd like any tweaks! 🚀
