#ifndef NETWORK_HEADERS_H
#define NETWORK_HEADERS_H

#include <cstdint>

// 플랫폼에 따라 필요한 네트워크 헤더를 포함합니다.
#ifdef _WIN32
    #include <winsock2.h>
    #include <ws2tcpip.h>
#else
    #include <arpa/inet.h>
    #include <netinet/in.h> // for in_addr
#endif


#pragma pack(push, 1)

// Ethernet Header (14 bytes)
struct EthernetHeader {
    uint8_t dest_mac[6];
    uint8_t src_mac[6];
    uint16_t eth_type;
};

// IP Header (20 bytes minimum)
struct IPHeader {
    uint8_t  hl:4,      // Header Length (in 32-bit words)
             v:4;       // Version (IPv4)
    uint8_t  tos;       // Type of Service
    uint16_t len;       // Total Length
    uint16_t id;        // Identification
    uint16_t off;       // Fragment Offset
    uint8_t  ttl;       // Time to Live
    uint8_t  p;         // Protocol (e.g., 6 for TCP)
    uint16_t sum;       // Checksum
    struct   in_addr ip_src, ip_dst; // Source and Destination Address
};

// TCP Header (20 bytes minimum)
struct TCPHeader {
    uint16_t sport;     // Source Port
    uint16_t dport;     // Destination Port
    uint32_t seq;       // Sequence Number
    uint32_t ack;       // Acknowledgement Number
    uint8_t  x2:4,      // Reserved
             off:4;     // Data Offset (Header Length in 32-bit words)
    uint8_t  flags;     // Control Flags (SYN, ACK, FIN, etc.)
    uint16_t win;       // Window
    uint16_t sum;       // Checksum
    uint16_t urp;       // Urgent Pointer
};

// ARP Header (28 bytes for IPv4 over Ethernet)
struct ARPHeader {
    uint16_t htype;    // Hardware Type
    uint16_t ptype;    // Protocol Type
    uint8_t  hlen;     // Hardware Address Length
    uint8_t  plen;     // Protocol Address Length
    uint16_t oper;     // Operation Code
    uint8_t  sha[6];   // Sender Hardware Address
    uint8_t  spa[4];   // Sender Protocol Address
    uint8_t  tha[6];   // Target Hardware Address
    uint8_t  tpa[4];   // Target Protocol Address
};


#pragma pack(pop)

#endif // NETWORK_HEADERS_H
