return {
  black = 0xff3b4252,
  white = 0xffe5e9f0,
  red = 0xffbf616a,
  green = 0xffa3be8c,
  blue = 0xff81a1c1,
  yellow = 0xffebcb8b,
  orange = 0xfff39660,
  magenta = 0xffb48ead,
  grey = 0xff7f8490,
  transparent = 0x00000000,

  bar = {
    bg = 0xe02e3440,
    border = 0xff2c2e34,
  },
  popup = {
    bg = 0xc02c2e34,
    border = 0xff7f8490
  },
  border = {
    highlighted = 0xffa5abb6,
  },
  bg1 = 0xff2e3440,
  bg2 = 0xff414550,

  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then return color end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
}
