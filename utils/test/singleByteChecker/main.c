/*There is test for all range: from 0 to 65535*/

#include <stdio.h>
#include <stdlib.h>
#include "utils.h"

int utilsSingleByteCheckerTest(unsigned short start, unsigned short stop, int assertion) {

	for(start; start < stop; ++start) {
		int checkState = utilsSingleByteChecker(start);
		if(checkState != assertion) {
			fprintf(stderr, "number %hu\t %d != %d", start, checkState, assertion);
			return 1;
		}
	}

	return 0;
}

int main(int argc, char* argv[]) {
	if(argc != 2) {
		fprintf(stderr, "Check number of arguments\n");
		return 1;
	}

	unsigned short lastNumberInRange = 65535;
	
	int testNumber = atoi(argv[1]);
	if(testNumber == 0)
		return utilsSingleByteCheckerTest(0, 256, 0);

	if(testNumber == 1)
		return utilsSingleByteCheckerTest(256, lastNumberInRange, 1);

	if(testNumber == 2)																									//Checking last number in range
		if(utilsSingleByteChecker(lastNumberInRange) != 1) {
			fprintf(stderr, "number %hu\t 0 != %d", lastNumberInRange, utilsSingleByteChecker(lastNumberInRange));
			return 1;
		}
		else { return 0; }

	fprintf(stderr, "Check number of test. TestNumber == %d\n", testNumber);
	return 1;
}