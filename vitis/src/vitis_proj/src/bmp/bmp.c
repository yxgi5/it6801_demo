#include "xil_types.h"
#include "ff.h"
#include "stdio.h"
#include "string.h"
#include "bmp.h"

unsigned char read_line_buf[1920 * 3];
unsigned char Write_line_buf[1920 * 3];
void bmp_read(char * bmp,u8 *frame,u32 stride, FIL *fil)
{
	short y,x;
	short Ximage;
	short Yimage;
	u32 iPixelAddr = 0;
	FRESULT res;
	unsigned char TMPBUF[64];
	unsigned int br;

	res = f_open(fil, bmp, FA_OPEN_EXISTING | FA_READ);
	if(res != FR_OK)
	{
		printf("error: f_open Failed!\r\n") ;
		return ;
	}
	res = f_read(fil, TMPBUF, 54, &br);
	if(res != FR_OK)
	{
		f_close(fil);
		printf("Failed to Read!\r\n") ;
		return ;
	}
	Ximage=(unsigned short int)TMPBUF[19]*256+TMPBUF[18];
	Yimage=(unsigned short int)TMPBUF[23]*256+TMPBUF[22];
	iPixelAddr = (Yimage-1)*stride ;

	for(y = 0; y < Yimage ; y++)
	{
		f_read(fil, read_line_buf, Ximage * 3, &br);
		for(x = 0; x < Ximage; x++)
		{
			frame[x * 3 + iPixelAddr + 1] = read_line_buf[x * 3 + 0];
			frame[x * 3 + iPixelAddr + 0] = read_line_buf[x * 3 + 1];
			frame[x * 3 + iPixelAddr + 2] = read_line_buf[x * 3 + 2];
			//frame[x * 4 + iPixelAddr + 0] = read_line_buf[x * 3 + 2];
			//frame[x * 4 + iPixelAddr + 1] = read_line_buf[x * 3 + 1];
			//frame[x * 4 + iPixelAddr + 2] = read_line_buf[x * 3 + 0];
			//frame[x * 4 + iPixelAddr + 3] = 0xff ;
		}
		iPixelAddr -= stride;
	}
	f_close(fil);
	printf("BMP read successfully!\r\n") ;
}


void bmp_write(char * name, char *head_buf, char *data_buf, u32 stride, FIL *fil)
{
	short y,x;
	short Ximage;
	short Yimage;
	u32 iPixelAddr = 0;
	FRESULT res;
	unsigned int br;         // File R/W count

	memset(&Write_line_buf, 0, 1920*3) ;

	res = f_open(fil, name, FA_CREATE_ALWAYS | FA_WRITE);
	if(res != FR_OK)
	{
		printf("error: f_open Failed!\r\n") ;
		return ;
	}
	res = f_write(fil, head_buf, 54, &br) ;
	if(res != FR_OK)
	{
		f_close(fil);
		printf("error: f_write Failed!\r\n") ;
		return ;
	}
	Ximage=(unsigned short)head_buf[19]*256+head_buf[18];
	Yimage=(unsigned short)head_buf[23]*256+head_buf[22];
	iPixelAddr = (Yimage-1)*stride ;
	for(y = 0; y < Yimage ; y++)
	{
		for(x = 0; x < Ximage; x++)
		{
			Write_line_buf[x*3 + 0] = data_buf[x*3 + iPixelAddr + 0] ;
			Write_line_buf[x*3 + 1] = data_buf[x*3 + iPixelAddr + 1] ;
			Write_line_buf[x*3 + 2] = data_buf[x*3 + iPixelAddr + 2] ;
		}
		res = f_write(fil, Write_line_buf, Ximage*3, &br) ;
		if(res != FR_OK)
		{
			f_close(fil);
			printf("error: f_write Failed!\r\n") ;
			return ;
		}
		iPixelAddr -= stride;
	}
	f_close(fil);
	printf("BMP write successfully!\r\n") ;
}

/*****************************************************************************/
/** scan_files.
* *
@description: Print a directory listing
* *
@param None
* *
@return None
* *
****************************************************************************/
FRESULT scan_files(char* path /* Start node to be scanned (also used as work area) */
) {
	FRESULT res;
	FILINFO fno;
	DIR dir;
	char *fn; /* This function assumes non-Unicode configuration */
	res = f_opendir(&dir, path); /* Open the directory */
	if (res == FR_OK) {
		for (;;) {
			res = f_readdir(&dir, &fno); /* Read a directory item */
			if (res != FR_OK || fno.fname[0] == 0)
				break; /* Break on error or end of dir */
			if (fno.fname[0] == '.')
				continue; /* Ignore dot entry */
			if (fno.fattrib & AM_DIR) { /* It is a directory */
				//break;
				continue;
			}
			if (fno.fattrib & AM_HID) { /* It is a directory */
				//break;
				continue;
			}
			if (fno.fattrib & AM_SYS) { /* It is a directory */
				//break;
				continue;
			}
			fn = fno.fname;
			/* It is a file. */
//			char *f;
//			memcpy(f, fn+strlen(fn)-4, 5);
			//xil_printf(" %s\n\r",f);
			if(!memcmp(".BMP", fn+strlen(fn)-4, 4))
				xil_printf(" %s/%s\n\r", path, fn);
		}
		f_closedir(&dir);
	}
	return res;
}
