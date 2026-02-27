/*
 * SPDX-License-Identifier: Apache-2.0
 */

#include <zephyr/kernel.h>

int main(void)
{
	printk("Hello World! %s\n", CONFIG_BOARD);

	while (1) {
		k_sleep(K_SECONDS(1));
		printk("alive\n");
	}

	return 0;
}
