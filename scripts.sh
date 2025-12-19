# Commands to set up a WAP on an Alpine Linux system
# with network address translation and DHCP server.

apk add hostapd busybox-extras iptables

# Configure /etc/hostapd/hostapd.conf and /etc/udhcpd.conf
# (Use the provided configuration files)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Configure iptables
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT

# Create an empty leases file
touch /var/lib/misc/udhcpd.leases

# Assign an IP Address to wlan0 (if needed)
ip addr add 192.168.2.1/24 dev wlan0
ip link set wlan0 up

# You may need to add a service file at /etc/init.d/udhcpd
nano /etc/init.d/udhcpd

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Add the following content to the service file:

# #!/sbin/openrc-run

# command=/usr/sbin/udhcpd
# command_args="/etc/udhcpd.conf"
# pidfile=/var/run/udhcpd.pid
# name="udhcpd"

# depend() {
#     need net
#     before dns
# }

chmod +x /etc/init.d/udhcpd

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Start the services
rc-service hostapd start
rc-service udhcpd start
sysctl net.ipv4.ip_forward=1 

rc-update add hostapd
rc-update add udhcpd
rc-update add sysctl


