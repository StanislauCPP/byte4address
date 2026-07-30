#include "utils.h"

# define SETTEDSECONBYTE 65280      // 1111111100000000

int utilsSingleByteChecker(unsigned short singleByteHolder) {
	unsigned short checker = (SETTEDSECONBYTE & singleByteHolder);
	
	if(checker == 0)
		return 0;

	return 1;
}