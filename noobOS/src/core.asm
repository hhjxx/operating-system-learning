	org 0x8200
	mov si,msg
putLoop:
	mov al,[si]
	add si,1
	cmp al,0
	je	fin 	;识别到结束符,输出结束
	mov ah,0x0e
	mov bx,15
	int 0x10
	jmp putLoop
fin:
	hlt
	jmp fin
msg:
	db 0x0a,0x0a ;换行两次
	db "boot success! enter Nos core!"
	db 0x0a
	db 0