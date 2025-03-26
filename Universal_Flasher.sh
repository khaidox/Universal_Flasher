#!/bin/bash
# Universal Flasher for OnePlus 13 – Super OOS Flasher
# Originally two scripts by FTH PHONE 1902 and Venkay,
# modified by docnok63 and Jonas Salo.
# Converted to a shell script that uses the pre-installed platform-tools.

# Change to the directory of this script
cd "$(dirname "$0")"

# Check if fastboot is available
if ! command -v fastboot &> /dev/null; then
  echo "fastboot not found. Please install platform-tools and ensure fastboot is in your PATH."
  exit 1
fi

echo "**********************************************************************"
echo
echo "              OnePlus 13 - Super OOS Flasher"
echo "       Originally two scripts by FTH PHONE 1902 and Venkay"
echo "            modified by docnok63 and Jonas Salo"
echo "**********************************************************************"
echo

echo "************************      START FLASH     ************************"
fastboot --set-active=a

# Flash the fastboot images first
fastboot flash boot OOS_FILES_HERE/boot.img
fastboot flash dtbo OOS_FILES_HERE/dtbo.img
fastboot flash init_boot OOS_FILES_HERE/init_boot.img
fastboot flash modem OOS_FILES_HERE/modem.img
fastboot flash recovery OOS_FILES_HERE/recovery.img
fastboot flash vbmeta OOS_FILES_HERE/vbmeta.img
fastboot flash vbmeta_system OOS_FILES_HERE/vbmeta_system.img
fastboot flash vbmeta_vendor OOS_FILES_HERE/vbmeta_vendor.img
fastboot flash vendor_boot OOS_FILES_HERE/vendor_boot.img

# Check if super.img exists and flash it if so
if [ -f "super.img" ]; then
    fastboot flash super super.img
else
    echo "super.img not found. Skipping super.img..."
fi

# Reboot to fastbootd
fastboot reboot fastboot
echo "*******************      REBOOTING TO FASTBOOTD     *******************"
echo "#################################"
echo "# Hit English on Phone          #"
echo "#################################"
read -n1 -s -r -p "Press any key to continue..."
echo

# Define excluded images (these should not be flashed again)
excluded_images=(
  "boot.img" "dtbo.img" "init_boot.img" "modem.img" "recovery.img"
  "vbmeta.img" "vbmeta_system.img" "vbmeta_vendor.img" "vendor_boot.img"
  "my_bigball.img" "my_carrier.img" "my_company.img" "my_engineering.img"
  "my_heytap.img" "my_manifest.img" "my_preload.img" "my_product.img"
  "my_region.img" "my_stock.img" "odm.img" "product.img" "system.img"
  "system_dlkm.img" "system_ext.img" "vendor.img" "vendor_dlkm.img"
)

# Loop through all .img files in OOS_FILES_HERE, skipping excluded ones
for file in OOS_FILES_HERE/*.img; do
    [ -e "$file" ] || continue  # Skip if no .img files exist
    base=$(basename "$file")
    skip=0
    for ex in "${excluded_images[@]}"; do
        if [ "$base" = "$ex" ]; then
            skip=1
            break
        fi
    done
    if [ $skip -eq 0 ]; then
       name="${base%.*}"  # Remove the .img extension
       echo "Flashing $name..."
       fastboot flash --slot=all "$name" "$file"
    fi
done

# Define the partitions list
partitions=(
  "my_bigball" "my_carrier" "my_engineering" "my_heytap" "my_manifest"
  "my_product" "my_region" "my_stock" "odm" "product" "system"
  "system_dlkm" "system_ext" "vendor" "vendor_dlkm" "my_company" "my_preload"
)

# If super.img does not exist, delete/create & flash logical partitions
if [ ! -f "super.img" ]; then
    for part in "${partitions[@]}"; do
        fastboot delete-logical-partition "${part}_a"
        fastboot delete-logical-partition "${part}_b"
        fastboot delete-logical-partition "${part}_a-cow"
        fastboot delete-logical-partition "${part}_b-cow"
        fastboot create-logical-partition "${part}_a" 1
        fastboot create-logical-partition "${part}_b" 1
        fastboot flash "$part" "OOS_FILES_HERE/${part}.img"
    done
else
    echo "super.img found. Logical partition flashes skipped..."
fi

echo "********************** CHECK ABOVE FOR ERRORS **************************"
echo "************** IF ERRORS, DO NOT BOOT INTO SYSTEM **********************"

# If super.img was not flashed, ask if the user wants to wipe data
if [ ! -f "super.img" ]; then
    read -p "Do you want to wipe data? (Y/N): " wipe_choice
    if [[ "$wipe_choice" =~ ^[Nn] ]]; then
         echo "*********************** NO NEED TO WIPE DATA ****************************"
         echo "***** Flashing complete. Hit any key to reboot the phone to Android *****"
         read -n1 -s -r -p "Press any key to continue..."
         echo
         fastboot reboot
         exit 0
    elif [[ "$wipe_choice" =~ ^[Yy] ]]; then
         echo "****************** FLASHING COMPLETE *****************"
         echo "Wipe data by tapping Format Data on the screen, enter the code, and press format data."
         echo "Phone will automatically reboot into Android after wipe is done."
         read -n1 -s -r -p "Press any key to continue..."
         echo
         exit 0
    fi
fi

# Ask if the user wants to prepare for root
read -p "Are you going to root your OP13? (Y/N): " root_choice
if [[ "$root_choice" =~ ^[Nn] ]]; then
    echo "***** Removing extra oplusstanvbk partitions *****"
    fastboot delete-logical-partition oplusstanvbk_a
    fastboot delete-logical-partition oplusstanvbk_b
    fastboot delete-logical-partition oplusstanvbk_a-cow
    fastboot delete-logical-partition oplusstanvbk_b-cow
    fastboot delete-logical-partition oplusstanvbk
    echo "***** Flashing COS .401 oplusstanvbk and GLO COS my_region *****"
    fastboot flash oplusstanvbk COS_FILES_HERE/oplusstanvbk.img
    fastboot flash my_region COS_FILES_HERE/my_region.img
else
    echo "***** Removing extra oplusstanvbk partitions *****"
    fastboot delete-logical-partition oplusstanvbk_a
    fastboot delete-logical-partition oplusstanvbk_b
    fastboot delete-logical-partition oplusstanvbk_a-cow
    fastboot delete-logical-partition oplusstanvbk_b-cow
    fastboot delete-logical-partition oplusstanvbk
    echo "***** After rooting, you must flash @greg44f's module to get signal back *****"
fi

# Ask if flashing from ColorOS or if the user wants to wipe data
read -p "Are you flashing from ColorOS or Want to WIPE DATA? (Y/N): " cos_choice
if [[ "$cos_choice" =~ ^[Nn] ]]; then
    echo "*********************** NO NEED TO WIPE DATA ****************************"
    echo "***** Flashing complete. Hit any key to reboot the phone to Android *****"
    read -n1 -s -r -p "Press any key to continue..."
    echo
    fastboot reboot
else
    echo "****************** FLASHING COMPLETE *****************"
    echo "Wipe data by tapping Format Data on the screen, enter the code, and press format data."
    echo "Phone will automatically reboot into Android after wipe is done."
fi

read -n1 -s -r -p "Press any key to exit..."
echo
