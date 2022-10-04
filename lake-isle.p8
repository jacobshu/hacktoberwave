pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
-- modified from https://www.lexaloffle.com/bbs/?pid=115136

function _init()
    -- replace palette
    pal({129,1,140,13,14,9,10,135,7,7,7,7,7,7,7},1)
    cls(1)
    -- poke(24372,1)
    -- gradients={1,5,8,9}
   
    star={
        x=10,
        y=120,
        size=32,
        angle=rnd(1),
    }
   
    speed=32
end

function _update()
    star.size=32+rnd(2)
    star.angle-=0.003
    star.x=star.x+0.01*(128-star.y)
    star.y=star.y-0.8
end

function _draw()
  cls(1)
  -- for i=2,#gradients do
  --   for j=128,-128,-1 do
  --     pal(0,gradients[i])
  --     draw_gradient(j,gradients[i-1])
  --   end
  -- end
  for x = 0, 128, 1 do
    for y = 0, 128, 1 do
      local intensity = x / 128
      local color = flr(y / 8) * dither(x, y, intensity)
      pset(x, y, color)
    end
  end
   
    -- draw star
  for i=0,3 do
      local x2=star.x+cos(star.angle+i/4)*star.size/2
      local y2=star.y+sin(star.angle+i/4)*star.size/2
      local x3=star.x+cos(3*star.angle-i/4)*star.size/2
      local y3=star.y+sin(3*star.angle-i/4)*star.size/2
      line_with_gradient(star.x,star.y,x2,y2,4)
      line_with_gradient(star.x,star.y,x3,y3,4)
  end
  smooth_circfill_with_gradient(star.x,star.y,star.size/4,12)
end
-->8
-- custom functions
function draw_gradient(y, cols)
      local ptn = 1
      color(cols)
      while y < 128 do
          rectfill(0, y, 127, y + 3,cols+dither[ptn])
          y += 8
          ptn = min(ptn + 1, 17)
      end
  end

  dither = {0x1000.0000,0x1000.8000,0x1000.8020,0x1000.a020,0x1000.a0a0,0x1000.a4a0,0x1000.a4a1,0x1000.a5a1,0x1000.a5a5,0x1000.e5a5,0x1000.e5b5,0x1000.f5b5,0x1000.f5f5,0x1000.fdf5,0x1000.fdf7,0x1000.fff7,0x1000.ffff,0x1000.ffff}
  function dither(xc, yc, value)
    local ox = xc % 3
    local oy = yc % 3
    if value > 0.9 then
      return 1
    elseif value > 0.75 then
      if (ox == 1 and oy == 1) then
        return 0
      end
      return 1
    elseif value > 0.6 then
      if (ox == oy or abs(ox - oy) == 1) then
        return 1
      end
      return 0
    elseif value > 0.45 then
      if (ox == oy) then
        return 0
      end
      return 1
    elseif value > 0.3 then
      if (ox == oy) then
        return 1
      end
      return 0
    elseif value > 0.15 then
      if (ox == oy or abs(ox - oy) == 1) then
        return 0
      end
      return 1
    elseif value > 0 then
      if (ox == 1 and oy == 1) then
        return 1
      end
      return 0
    end
    return 0
  end

function pset_gradient(x,y,n)
    if n>0 then
        local color=pget(x,y)

        local newColor=min(flr(color+n),9)
        pset(x,y,newColor)
    end
end

function line_with_gradient(x1,y1,x2,y2,n)
    local offset=0.5
    x1,y1 = flr(x1+offset),flr(y1+offset)
    x2,y2 = flr(x2+offset),flr(y2+offset)
    local xr=x2-x1
    local yr=y2-y1
   
    if abs(xr)>abs(yr) then
        for x=x1,x2,sgn(xr) do
            local prog=(x-x1)/xr
            local y=flr(y1+yr*prog+offset)
            local _n=ceil(n-prog*n)
            pset_gradient(x,y,_n)
        end
    else
        for y=y1,y2,sgn(yr) do
            local prog=(y-y1)/yr
            local x=flr(x1+xr*prog+offset)
            local _n=ceil(n-prog*n)
            pset_gradient(x,y,_n)
        end
    end
end

function smooth_circfill_with_gradient(x,y,radius,n)
    -- from https://gamedev.stackexchange.com/questions/176036/how-to-draw-a-smoother-solid-fill-circle
    local diameter=radius*2
    for _y=0,diameter do
        for _x=0,diameter do
            local _n=n-((_x-radius)^2+(_y-radius)^2)/radius^2*9
            pset_gradient(x+_x-radius,y+_y-radius,_n)
        end
    end
end
__sfx__
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001200001415515155151551c1551015514155151551c1551015512155151551a155121551c1551c174151551415515155151551c1551015514155151551c1551015512155151551a155121551c1551c17415155
310900000d1550d1740d1740d17410155101741017410174101051c1051510515105151551517415174151740c1550c1740c1740c17410155101741017410174001050010500105001051c1551c1741c1741c174
001200000e155101551215515155151740e1550e174121551c1551c17415155151740e1550e17412155121740e155101551515512155121741c1551c174121551a1550e1741215515155151741c1551c17412174
001200201415515155151551c1551015514155151551c1551015512155151551a155121551c15515155101551415515155151551c1551015514155151551c1551015512155151551a155121551c1551515510155
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
012400001b3001c30028310283202833028340283402834028340283402a3402d3402f340313402f3402d3402a34028340283402834028340283402834028340283402f3002a3402d3402f340313402f3402d340
012400002d3402f3402f3402f3402f3402f3402f3402f3402f3402f3402f3402f3402830028300283102831028320283202832028320283302833028330283302834028340283402834028340283402834028340
011000002d3402f3402f3402f3402f3402f3402f3402f3402f3402f3402f3402f3402f3402f3402f3402f3402f3402f3402f3402f3402f3002f3002f3002f3000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
49240000097600070009760007000976000700097600070009760007000976000700097600070009760007000d760007000d760007000d760007000d760007001476000700147600070012760007001276000700
__music__
00 014a4544
00 034a4344
01 044a1444
00 040a1444
00 040a1444
00 040b1444

