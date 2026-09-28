#include <iostream>
#include <fstream>
#include <string>

int main(int argc, const char** argv) {
	if(argc != 3) {
		std::cerr << "Wrong arguments number" << std::endl;	
		return 1;
	}

	std::fstream expectedOutput(argv[1], std::ios::in), realOutput(argv[2], std::ios::in);

	if(!expectedOutput.is_open() || !realOutput.is_open()) {
		std::cerr << "real output file and/or expected output file wasn't opened" << std::endl;
		return 1;
	}

	while(!expectedOutput.eof() || !realOutput.eof()) {
		std::string realOutputString, expectedOutputString;
		std::getline(expectedOutput,	expectedOutputString);
		std::getline(realOutput,			realOutputString);
		if(expectedOutputString != realOutputString) {
			std::cerr << expectedOutputString << "!=" << realOutputString << std::endl;
			return 1;
		}		
	}
	
  return 0;
}