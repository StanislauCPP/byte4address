#pragma once
/*For single byte we need to have setted only first byte. Bytes after must equal zeroes*/

/*Checking byteHolder for overrun - only first byte must be setted.
  Return 0 if only first byte setted, if not only return 1;
  */
int utilsSingleByteChecker(unsigned short singleByteHolder);