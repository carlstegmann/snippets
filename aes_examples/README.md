# Example run of encryption.rb

To give you an example of encrypting a message using aes in gcm mode run encryption.rb

```bash
$ ./encryption.rb
Secret key written to file.
IV written to file.
auth_data written to file.
encrypted message written to file.
tag written to file.
You can run the decryptin script now. This will print you the secret data. Note that you will not find this string if you hexdump the resulting file "encrypted_message".
Remember to keep your secret key secret! This script is only for education and not for productive use!
```

# Content of encrypted message on disk

The encrypted message can be found in plaintext in the encryption.rb file and it will be printed to you through the decryption.rb script if you have run the encryption.rb file first.
This is how the encrypted message looks when its located in disk. This is for data at rest security.

```bash
$ xxd encrypted_message
00000000: 57b5 9507 0d68 9ab5 945e ca79 ce58 49db  W....h...^.y.XI.
00000010: 1bac 5fa7 d017 040f 51e9 3df1 9490 e7b1  .._.....Q.=.....
00000020: 6b44 56c3 3e32 be49 ca8b 2826 60c7 e8fc  kDV.>2.I..(&`...
00000030: 4220 63c5 b915 b85f 53b0 0cec 7704 6e10  B c...._S...w.n.
00000040: c9a7 2574 43e7 9937 0ab4 96fe 78fe f71a  ..%tC..7....x...
00000050: e09d 1029 469a b88f 1704 0fa9 fcde c44d  ...)F..........M
00000060: a733 b3d5 0894 3435 5964 b70a            .3....45Yd..
```

# Example run of decryption.rb

The decryption.rb will decrypt the plaintext message from within encryption.rb for you, as you can not read it using a texteditor or hexeditor for the encrypted_message file.

```bash
$ ./decryption.rb
Encrypted message content:
Wµ•hšµ”^ÊyÎXIÛ¬_§ĞQé=ñ”ç±kDVÃ>2¾IÊ‹(&`ÇèüB cÅ¹¸_S°ìwnÉ§%tCç™7
´–şxş÷à)Fš¸©üŞÄM§3³Õ”45Yd·
Key used to encrypt / decrypt:
ñ9k/~‹B©¼ã#¼ÙÁ†VB¡Ú¸w+taQZkØ¥
Used nonce / iv you name it:
ü¡ûÈL—’å
Auth data:
64db296346866b63d8c8
Auth tag:
;'©JHJ‚9·Û"xõÅ
This is my secret message. Can you read this message in the file on disk using a texteditor or a hexeditor?
```
