CYLS EQU 10	;CYLS为常量,最大柱面数	
	org 0x7c00	;将本bootloader装载在指定内存地址中
;寄存器初始化
entry:
	mov ax,0
	mov ss,ax
	mov sp,0x7c00
	mov ds,ax
	mov es,ax
	mov si,errMsg
;开始第一次读盘
	mov ax,0x0820
	mov es,ax	;设置目标段地址
	mov dh,0 	;磁头号
	mov ch,0 	;柱面号
	mov cl,2 	;扇区号(1号扇区用于装载本bootloader,所以从2号开始读盘)
readLoop:
	mov ah,0x02 ;开始读盘
	mov al,1 	;每次读取一个扇区
	mov bx,0 	;从es:bx开始存储读盘数据
	mov dl,0 	;0号驱动器
	int 0x13 	;调用磁盘bios
	jnc nextSector 	;如果读盘正常,则开始读下一个扇区(共18个扇区)
putLoop:  	;此时si=errMsg
	mov al,[si]
	add si,1
	cmp al,0
	je	iplEnd 	;识别到结束符,输出结束
	mov ah,0x0e
	mov bx,15
	int 0x10
	jmp putLoop
nextSector:
	mov ax,es
	add ax,512/16 	;(段地址增加512字节)
	mov es,ax 	;由于es不能直接add,需要由ax赋值
	add cl,1 	;扇区号加1
	cmp cl,18
	jbe readLoop 	;如果扇区小于18,继续读取该柱面的剩余扇区
	mov cl,1	;如果扇区号大于18,开始读该柱面的另一磁头,扇区号重设为1
	add dh,1	;磁头号加1
	cmp dh,2
	jb	readLoop	;磁头号<2,继续读取
	mov cl,1	;磁头号>=2,重置扇区号和磁头号,开始读取下一个柱面
	mov dh,0
	add ch,1	;柱面号加1
	cmp ch,CYLS
	jb	readLoop	;柱面号小于最大柱面号,继续读取
	jmp 0x8200	;软盘内容读取完毕,启动内核
iplEnd:
	hlt
	jmp iplEnd

;以下是消息内容
errMsg:
	db 0x0a,0x0a ;换行两次
	db "bootloader error! system boot failed!"
	db 0x0a
	db 0
	times 510-($-$$) db 0
	db 0x55,0xaa