Nos.img:boot.img core.img Makefile
	./dd.exe if=/dev/zero of=../Nos.img bs=512 count=2880
	./dd.exe if=../boot.img of=../Nos.img bs=1 seek=0 count=512 conv=notrunc
	./dd.exe if=../core.img of=../Nos.img bs=512 seek=1 conv=notrunc
	
boot.img:../src/boot.asm Makefile
	./nasm.exe ../src/boot.asm -f bin -o ../bin/boot.bin
	./dd.exe if=../bin/boot.bin of=../boot.img bs=512 count=1
	
core.img:../src/core.asm Makefile
	./nasm.exe ../src/core.asm -f bin -o ../bin/core.bin
	./dd.exe if=../bin/core.bin of=../core.img
	
cleanAll:Makefile
	del ..\boot.img
	del ..\bin\boot.bin
	del ..\bin\core.bin