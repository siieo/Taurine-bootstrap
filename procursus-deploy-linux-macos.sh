#!/bin/bash
if [ $(uname) = "Darwin" ]; then
	if [ $(uname -p) = "arm" ] || [ $(uname -p) = "arm64" ]; then
		echo "It's recommended this script be ran on macOS/Linux with a clean iOS device running checkra1n attached unless migrating from older bootstrap."
		read -p "Press enter to continue"
		ARM=yes
	fi
fi

echo "Taurinera1n deployment script"
echo "(C) 2020, CoolStar. All Rights Reserved"

echo ""
echo "Before you begin: This script includes experimental migration from older bootstraps to Procursus/Taurine."
echo "If you're already jailbroken, you can run this script on the checkra1n device."
echo "If you'd rather start clean, please Reset System via the Loader app first."
read -p "Press enter to continue"

if ! which curl >> /dev/null; then
	echo "Error: curl not found"
	exit 1
fi
if [[ "${ARM}" = yes ]]; then
	if ! which zsh >> /dev/null; then
		echo "Error: zsh not found"
		exit 1
	fi
else
	if which iproxy >> /dev/null; then
		iproxy 4444 44 >> /dev/null 2>/dev/null &
	else
		echo "Error: iproxy not found"
		exit 1
	fi
fi
rm -rf taurine-tmp
mkdir taurine-tmp
cd taurine-tmp

echo '#!/bin/zsh' > taurine-device-deploy.sh
if [[ ! "${ARM}" = yes ]]; then
	echo 'cd /var/root' >> taurine-device-deploy.sh
fi
echo 'if [[ -f "/.bootstrapped" ]]; then' >> taurine-device-deploy.sh
echo 'mkdir -p /taurine && mv migration /taurine' >> taurine-device-deploy.sh
echo 'chmod 0755 /taurine/migration' >> taurine-device-deploy.sh
echo '/taurine/migration' >> taurine-device-deploy.sh
echo 'rm -rf /taurine' >> taurine-device-deploy.sh
echo 'else' >> taurine-device-deploy.sh
echo 'VER=$(/binpack/usr/bin/plutil -key ProductVersion /System/Library/CoreServices/SystemVersion.plist)' >> taurine-device-deploy.sh
echo 'if [[ "${VER%.*}" -ge 12 ]] && [[ "${VER%.*}" -lt 13 ]]; then' >> taurine-device-deploy.sh
echo 'CFVER=1700' >> taurine-device-deploy.sh
echo 'elif [[ "${VER%.*}" -ge 13 ]]; then' >> taurine-device-deploy.sh
echo 'CFVER=1700' >> taurine-device-deploy.sh
echo 'elif [[ "${VER%.*}" -ge 14 ]]; then' >> taurine-device-deploy.sh
echo 'CFVER=1700' >> taurine-device-deploy.sh
echo 'else' >> taurine-device-deploy.sh
echo 'echo "${VER} not compatible."' >> taurine-device-deploy.sh
echo 'exit 1' >> taurine-device-deploy.sh
echo 'fi' >> taurine-device-deploy.sh
echo 'mount -uw -o union /dev/disk0s1s1' >> taurine-device-deploy.sh
echo 'rm -rf /etc/profile' >> taurine-device-deploy.sh
echo 'rm -rf /etc/profile.d' >> taurine-device-deploy.sh
echo 'rm -rf /etc/alternatives' >> taurine-device-deploy.sh
echo 'rm -rf /etc/apt' >> taurine-device-deploy.sh
echo 'rm -rf /etc/ssl' >> taurine-device-deploy.sh
echo 'rm -rf /etc/ssh' >> taurine-device-deploy.sh
echo 'rm -rf /etc/dpkg' >> taurine-device-deploy.sh
echo 'rm -rf /Library/dpkg' >> taurine-device-deploy.sh
echo 'rm -rf /var/cache' >> taurine-device-deploy.sh
echo 'rm -rf /var/lib' >> taurine-device-deploy.sh
echo 'tar --preserve-permissions -xkf bootstrap_${CFVER}.tar -C /' >> taurine-device-deploy.sh
printf %s 'SNAPSHOT=$(snappy -s | ' >> taurine-device-deploy.sh
printf %s "cut -d ' ' -f 3 | tr -d '\n')" >> taurine-device-deploy.sh
echo '' >> taurine-device-deploy.sh
echo 'fi' >> taurine-device-deploy.sh
echo '/usr/libexec/firmware' >> taurine-device-deploy.sh
echo 'mkdir -p /etc/apt/sources.list.d/' >> taurine-device-deploy.sh
echo 'echo "Types: deb" > /etc/apt/sources.list.d/taurine.sources' >> taurine-device-deploy.sh
echo 'echo "URIs: https://repo.theodyssey.dev/" >> /etc/apt/sources.list.d/taurine.sources' >> taurine-device-deploy.sh
echo 'echo "Suites: ./" >> /etc/apt/sources.list.d/taurine.sources' >> taurine-device-deploy.sh
echo 'echo "Components: " >> /etc/apt/sources.list.d/taurine.sources' >> taurine-device-deploy.sh
echo 'echo "" >> /etc/apt/sources.list.d/taurine.sources' >> taurine-device-deploy.sh
echo 'mkdir -p /etc/apt/preferences.d/' >> taurine-device-deploy.sh
echo 'echo "Package: *" > /etc/apt/preferences.d/taurine' >> taurine-device-deploy.sh
echo 'echo "Pin: release n=taurine-ios" >> /etc/apt/preferences.d/taurine' >> taurine-device-deploy.sh
echo 'echo "Pin-Priority: 1001" >> /etc/apt/preferences.d/taurine' >> taurine-device-deploy.sh
echo 'echo "" >> /etc/apt/preferences.d/taurine' >> taurine-device-deploy.sh
echo 'if [[ $VER = 12.1* ]] || [[ $VER = 12.0* ]]; then' >> taurine-device-deploy.sh
echo 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/X11:/usr/games dpkg -i essential_0-4_iphoneos-arm.deb' >> taurine-device-deploy.sh
echo 'fi' >> taurine-device-deploy.sh
echo 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/X11:/usr/games dpkg -i org.coolstar.sileo_2.0.3_iphoneos-arm.deb' >> taurine-device-deploy.sh
echo 'uicache -p /Applications/Sileo.app' >> taurine-device-deploy.sh
echo 'echo -n "" > /var/lib/dpkg/available' >> taurine-device-deploy.sh
echo 'touch /.mount_rw' >> taurine-device-deploy.sh
echo 'touch /.installed_taurine' >> taurine-device-deploy.sh
echo 'rm bootstrap*.tar*' >> taurine-device-deploy.sh
echo 'rm migration' >> taurine-device-deploy.sh
echo 'rm org.coolstar.sileo_2.0.3_iphoneos-arm.deb' >> taurine-device-deploy.sh
echo 'rm essential_0-4_iphoneos-arm.deb' >> taurine-device-deploy.sh
echo 'rm taurine-device-deploy.sh' >> taurine-device-deploy.sh

echo "Downloading Resources..."
curl -L -O https://raw.githubusercontent.com/siieo/Taurine-bootstrap/main/bootstrap_1700.tar -O https://raw.githubusercontent.com/siieo/Taurine-bootstrap/main/migration -O https://raw.githubusercontent.com/siieo/Taurine-bootstrap/main/org.coolstar.sileo_2.0.3_iphoneos-arm.deb -O https://raw.githubusercontent.com/siieo/Taurine-bootstrap/main/essential_0-4_iphoneos-arm.deb
clear
if [[ ! "${ARM}" = yes ]]; then
	echo "Copying Files to your device"
	echo "Default password is: alpine"
	scp -P4444 -o "StrictHostKeyChecking no" -o "UserKnownHostsFile=/dev/null" bootstrap_1700.tar migration org.coolstar.sileo_2.0.3_iphoneos-arm.deb essential_0-4_iphoneos-arm.deb taurine-device-deploy.sh root@127.0.0.1:/var/root/
	clear
fi
echo "Installing Procursus bootstrap and Sileo on your device"
if [[ "${ARM}" = yes ]]; then
	zsh ./taurine-device-deploy.sh
else
	echo "Default password is: alpine"
	ssh -p4444 -o "StrictHostKeyChecking no" -o "UserKnownHostsFile=/dev/null" root@127.0.0.1 "zsh /var/root/taurine-device-deploy.sh"
	echo "All Done!"
	killall iproxy
fi
