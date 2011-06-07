#import <Chiles/ChString.h>
#import <Chiles/ChList.h>
#import <Chiles/ChDictionary.h>
#import <Chiles/ChInteger.h>
#import <Chiles/Utils.h>
#import <unistd.h>

int main() {
	ChPrint(@"hola %d %x\n", 5, 928);
	ChList *l = [[ChList alloc] init];
	[l insert:@"Primero"];
	[l insert:@"Segundo"];
	[l insert:@"Tercero"];

	ChObject<Iterator> *it;
	ChString *s;

	it = [l iterator];
	
	while([it hasNext]) {
		s = (ChString *)[it next];
		ChPrint(@"%@\n", s);
	}

	return 0;
}

