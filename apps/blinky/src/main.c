#include <stdio.h>
#include <zephyr/kernel.h>
#include <zephyr/drivers/gpio.h>

#define SLEEP_TIME_MS   500

#define LED0_NODE DT_ALIAS(led0)
#define LED1_NODE DT_ALIAS(led1)
#define LED2_NODE DT_ALIAS(led2)
#define LED3_NODE DT_ALIAS(led3)

static const struct gpio_dt_spec led0 = GPIO_DT_SPEC_GET(LED0_NODE, gpios);
static const struct gpio_dt_spec led1 = GPIO_DT_SPEC_GET(LED1_NODE, gpios);
static const struct gpio_dt_spec led2 = GPIO_DT_SPEC_GET(LED2_NODE, gpios);
static const struct gpio_dt_spec led3 = GPIO_DT_SPEC_GET(LED3_NODE, gpios);

int main(void)
{
  const struct gpio_dt_spec * leds[4] = {
    &led0, &led1, &led2, &led3
  };
  int ret;
  bool led_state = true;

  for(uint8_t i = 0; i < 4; i++){
    if (!gpio_is_ready_dt(leds[i]))
      return 0;

    ret = gpio_pin_configure_dt(leds[i], GPIO_OUTPUT_ACTIVE);

    if (ret < 0)
      return 0;
  }

  uint8_t counter = 0;

  printk("Blinky started\n");

  while (1) {
    for(uint8_t i = 0; i < 4; i++){
      ret = gpio_pin_set_dt(leds[i], i == counter);
      if (ret < 0)
        return 0;
      printk("LED%d state: %s\n", counter + 1, i == counter ? "ON" : "OFF");
    }
    counter = ++counter >= 4 ? 0 : counter;
    k_msleep(SLEEP_TIME_MS);
  }
  return 0;
}
