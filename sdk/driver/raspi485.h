// Code to send DE / RE signal out over GPIO, for RS485 on Raspberry Pi


#ifndef __RASPI485_H__
#define __RASPI485_H__

// You might need to change this for some reason?
#define GPIO_CHIP_NAME "gpiochip0"

struct gpiod_line *r485_line;
struct gpiod_chip *r485_chip;

void raspi485_begin() {
	r485_chip = gpiod_chip_open_by_name(GPIO_CHIP_NAME);
	r485_line = gpiod_chip_get_line(r485_chip, GPIO_PIN_NUM);
	gpiod_line_request_output(r485_line, "YASDI", 0);
}

void raspi485_listen() {
	gpiod_line_set_value(r485_line, 0);
}

void raspi485_speak() {
	gpiod_line_set_value(r485_line, 1);
}

void raspi485_end() {
	if(r485_line) {
		gpiod_line_set_value(r485_line, 0);
		gpiod_line_request_input(r485_line, "YASDI");	// Return to high impedence
		gpiod_line_close_chip(r485_line);
	}
}

#endif
