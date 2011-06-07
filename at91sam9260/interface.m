#import <Chiles/ChString.h>
#import <Chiles/ChConf.h>
#import <Chiles/ChList.h>
#import <dataflash.h>
#import <insts/adc.h>
#import <insts/add.h>
#import <insts/and.h>
#import <insts/bic.h>
#import <insts/bkpt.h>
#import <insts/bl.h>
#import <insts/blx.h>
#import <insts/bx.h>
#import <insts/cdp.h>
#import <insts/clz.h>
#import <insts/cmn.h>
#import <insts/cmp.h>
#import <insts/cps.h>
#import <insts/eor.h>
#import <insts/ldc.h>
#import <insts/ldm1.h>
#import <insts/ldm2.h>
#import <insts/ldm3.h>
#import <insts/ldrb.h>
#import <insts/ldrbt.h>
#import <insts/ldr.h>
#import <insts/ldrd.h>
#import <insts/ldrex.h>
#import <insts/ldrh.h>
#import <insts/ldrsb.h>
#import <insts/ldrsh.h>
#import <insts/ldrt.h>
#import <insts/mcr.h>
#import <insts/mcrr.h>
#import <insts/mla.h>
#import <insts/mov.h>
#import <insts/mrc.h>
#import <insts/mrrc.h>
#import <insts/mrs.h>
#import <insts/msri.h>
#import <insts/msrr.h>
#import <insts/mul.h>
#import <insts/mvn.h>
#import <insts/orr.h>
#import <insts/rsb.h>
#import <insts/rsc.h>
#import <insts/sbc.h>
#import <insts/setend.h>
#import <insts/smla.h>
#import <insts/smlad.h>
#import <insts/smlal.h>
#import <insts/smlald.h>
#import <insts/smlalxy.h>
#import <insts/smlaw.h>
#import <insts/smlsd.h>
#import <insts/smlsld.h>
#import <insts/smmla.h>
#import <insts/smmls.h>
#import <insts/smmul.h>
#import <insts/smuad.h>
#import <insts/smul.h>
#import <insts/smull.h>
#import <insts/smulw.h>
#import <insts/smusd.h>
#import <insts/stc.h>
#import <insts/stm1.h>
#import <insts/stm2.h>
#import <insts/strb.h>
#import <insts/strbt.h>
#import <insts/str.h>
#import <insts/strd.h>
#import <insts/strex.h>
#import <insts/strh.h>
#import <insts/strt.h>
#import <insts/sub.h>
#import <insts/swi.h>
#import <insts/swpb.h>
#import <insts/swp.h>
#import <insts/sxtab16.h>
#import <insts/sxtab.h>
#import <insts/sxtah.h>
#import <insts/sxtb16.h>
#import <insts/sxtb.h>
#import <insts/sxth.h>
#import <insts/teq.h>
#import <insts/tst.h>
#import <insts/umaal.h>
#import <insts/umlal.h>
#import <insts/umull.h>
#import <insts/uxtab16.h>
#import <insts/uxtab.h>
#import <insts/uxtah.h>
#import <insts/uxtb16.h>
#import <insts/uxtb.h>
#import <insts/uxth.h>


ARMDevice *dataflash(UWord base, ARMCore *core, ChString *name, ChConf *conf) {
	UWord size;
	ChString *strSize;

	strSize = [conf get:@"size" at:name];
	size = [strSize toInt];

	ARMDevice *device = [[Dataflash alloc] initWithSize:size
		                                   withCore:core
						   withBase:base];

	return device;
}

ChList *instructions() {
	ChList *result = [[ChList alloc] init];

	[result insert:(id)[BlInstruction class]];
	[result insert:(id)[BlxInstruction class]];
	[result insert:(id)[BxInstruction class]];
	[result insert:(id)[MlaInstruction class]];
	[result insert:(id)[MulInstruction class]];
	[result insert:(id)[SmlaInstruction class]];
	[result insert:(id)[SmuadInstruction class]];
	[result insert:(id)[SmladInstruction class]];
	[result insert:(id)[SmlalInstruction class]];
	[result insert:(id)[SmlalxyInstruction class]];
	[result insert:(id)[SmlaldInstruction class]];
	[result insert:(id)[SmlawInstruction class]];
	[result insert:(id)[SmusdInstruction class]];
	[result insert:(id)[SmlsdInstruction class]];
	[result insert:(id)[SmlsldInstruction class]];
	[result insert:(id)[SmmulInstruction class]];
	[result insert:(id)[SmmlaInstruction class]];
	[result insert:(id)[SmmlsInstruction class]];
	[result insert:(id)[SmulInstruction class]];
	[result insert:(id)[SmullInstruction class]];
	[result insert:(id)[SmulwInstruction class]];
	[result insert:(id)[UmaalInstruction class]];
	[result insert:(id)[UmlalInstruction class]];
	[result insert:(id)[UmullInstruction class]];
	[result insert:(id)[Sxtb16Instruction class]];
	[result insert:(id)[Sxtb16Instruction class]];
	[result insert:(id)[SxtbInstruction class]];
	[result insert:(id)[SxtabInstruction class]];
	[result insert:(id)[SxthInstruction class]];
	[result insert:(id)[SxtahInstruction class]];
	[result insert:(id)[Uxtab16Instruction class]];
	[result insert:(id)[UxtbInstruction class]];
	[result insert:(id)[UxtabInstruction class]];
	[result insert:(id)[UxthInstruction class]];
	[result insert:(id)[UxtahInstruction class]];
	[result insert:(id)[LdrtInstruction class]];
	[result insert:(id)[LdrInstruction class]];
	[result insert:(id)[LdrbtInstruction class]];
	[result insert:(id)[LdrbInstruction class]];
	[result insert:(id)[LdrdInstruction class]];
	[result insert:(id)[LdrexInstruction class]];
	[result insert:(id)[LdrhInstruction class]];
	[result insert:(id)[LdrsbInstruction class]];
	[result insert:(id)[LdrshInstruction class]];
	[result insert:(id)[StrtInstruction class]];
	[result insert:(id)[StrInstruction class]];
	[result insert:(id)[StrbtInstruction class]];
	[result insert:(id)[StrbInstruction class]];
	[result insert:(id)[StrdInstruction class]];
	[result insert:(id)[StrexInstruction class]];
	[result insert:(id)[StrhInstruction class]];
	[result insert:(id)[Sxtb16Instruction class]];
	[result insert:(id)[SxtbInstruction class]];
	[result insert:(id)[SxtabInstruction class]];
	[result insert:(id)[SxthInstruction class]];
	[result insert:(id)[SxtahInstruction class]];
	[result insert:(id)[Uxtb16Instruction class]];
	[result insert:(id)[Uxtab16Instruction class]];
	[result insert:(id)[UxtbInstruction class]];
	[result insert:(id)[UxtabInstruction class]];
	[result insert:(id)[UxthInstruction class]];
	[result insert:(id)[UxtahInstruction class]];
	[result insert:(id)[AdcInstruction class]];
	[result insert:(id)[AddInstruction class]];
	[result insert:(id)[AndInstruction class]];
	[result insert:(id)[BicInstruction class]];
	[result insert:(id)[CmnInstruction class]];
	[result insert:(id)[CmpInstruction class]];
	[result insert:(id)[EorInstruction class]];
	[result insert:(id)[MovInstruction class]];
	[result insert:(id)[MvnInstruction class]];
	[result insert:(id)[OrrInstruction class]];
	[result insert:(id)[RsbInstruction class]];
	[result insert:(id)[RscInstruction class]];
	[result insert:(id)[SbcInstruction class]];
	[result insert:(id)[SubInstruction class]];
	[result insert:(id)[TeqInstruction class]];
	[result insert:(id)[TstInstruction class]];
	[result insert:(id)[ClzInstruction class]];
	[result insert:(id)[SwpbInstruction class]];
	[result insert:(id)[SwpInstruction class]];
	[result insert:(id)[MrrcInstruction class]];
	[result insert:(id)[CdpInstruction class]];
	[result insert:(id)[LdcInstruction class]];
	[result insert:(id)[McrInstruction class]];
	[result insert:(id)[McrrInstruction class]];
	[result insert:(id)[MrcInstruction class]];
	[result insert:(id)[StcInstruction class]];
	[result insert:(id)[MrsInstruction class]];
	[result insert:(id)[MsriInstruction class]];
	[result insert:(id)[MsrrInstruction class]];
	[result insert:(id)[CpsInstruction class]];
	[result insert:(id)[SetendInstruction class]];
	[result insert:(id)[Ldm1Instruction class]];
	[result insert:(id)[Ldm2Instruction class]];
	[result insert:(id)[Stm1Instruction class]];
	[result insert:(id)[Stm2Instruction class]];
	[result insert:(id)[BkptInstruction class]];
	[result insert:(id)[SwiInstruction class]];

	return result;
}

