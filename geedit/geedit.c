#include <stdio.h>
#include <stdint.h>
#include <sys/types.h>

struct metadata {
	char		magic[16];	/* Magic value. */
	uint32_t	version;	/* Version number. */
	uint32_t	flags;	/* Additional flags. */
	uint16_t	ealgo;	/* Encryption algorithm. */
	uint16_t	keylen;	/* Key length. */
	uint16_t	aalgo;	/* Authentication algorithm. */
	uint64_t	provsize;	/* Provider's size. */
	uint32_t	sectorsize;	/* Sector size. */
	uint8_t		keys;	/* Available keys. */
	int32_t		iterations;	/* Number of iterations for PKCS#5v2. */
	uint8_t		salt[64]; /* Salt. */
	uint8_t		mkeys[2 * 64]; /* Encrypted master key (iv,data,hmac) */
	u_char		hash[16];	/* MD5 hash. */
} __packed;


int main (int argc, char **argv){
    if (argc == 1){
        puts("You have to provide GELI metadata file as argument");
        return 1;
    }
    const char *filepath = argv[1];
    struct metadata md;
    FILE *f;

    printf("opening: %s\n", filepath);
    f = fopen(filepath,"rb");
    if (f == NULL){
        printf("Error reading file %s\n", filepath);
        return 1;
    }

    fread(&md, sizeof(md),1,f);
	
	printf("     magic: %s\n", md.magic);
	printf("   version: %u\n", (u_int)md.version);
	printf("     flags: 0x%x\n", (u_int)md.flags);
	printf("     ealgo: %u\n", (u_int)md.ealgo);
	printf("    keylen: %u\n", (u_int)md.keylen);
	printf("     aalgo: %s\n", (u_int)(md.aalgo));
	printf("  provsize: %ju\n", (uintmax_t)md.provsize);
	printf("sectorsize: %u\n", (u_int)md.sectorsize);
	printf("      keys: 0x%02x\n", (u_int)md.keys);
}
