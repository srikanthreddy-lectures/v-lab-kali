# Dockerfile kali-kmit

# Official base image
FROM kalilinux/kali-rolling

# Apt
RUN apt -y update && apt -y upgrade && apt -y autoremove && apt clean

# Tools
RUN apt install dbus-x11 aircrack-ng netdiscover iproute2 wireshark crackmapexec crunch curl dirb dirbuster dnsenum dnsrecon dnsutils dos2unix enum4linux exploitdb ftp git gobuster hashcat hping3 hydra impacket-scripts john joomscan masscan metasploit-framework mimikatz nasm ncat netcat-traditional nikto nmap patator php powersploit proxychains python3-pip python2 python3 recon-ng responder samba samdump2 smbclient smbmap snmp socat sqlmap sslscan theharvester vim wafw00f weevely wfuzz whois wordlists wpscan novnc -y --no-install-recommends

# DE and vncserver
RUN DEBIAN_FRONTEND=noninteractive apt install -y xfce4 xfce4-goodies x11vnc xvfb
RUN mkdir ~/.vnc
RUN x11vnc -storepasswd kmit ~/.vnc/passwd

# Clone noVNC from github
RUN git clone https://github.com/kanaka/noVNC.git /root/noVNC \
        && git clone https://github.com/kanaka/websockify /root/noVNC/utils/websockify \
        && rm -rf /root/noVNC/.git \
        && rm -rf /root/noVNC/utils/websockify/.git

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Modify the launch script 'ps -p'
RUN sed -i -- "s/ps -p/ps -o pid | grep/g" /root/noVNC/utils/novnc_proxy

EXPOSE 8080
RUN apt install supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# Set working directory to /root
WORKDIR /root

