local a,F,z,b,M,X,H,K
M=math
X=M.floor
H=M.cos
K=M.sin
a = 0
F = 0
z = {}
b = {}

-- clear screen before starting
term.clear()

while 1 do
    -- Too long without yielding Fix
    os.queueEvent('')
    os.pullEvent()
    local i,j
    j=0
    -- zeros arrays
    for l=1, 1760 do
        z[l] = 0
    end
    for t=1, 1760 do
        b[t] = ' '
    end
    -- calculate donut
    while j < 6.28 do
        j=j+0.07
        i=0
        while i < 6.28 do
            i=i+0.02

            local c,d,e,f,g,h,D,l,m,n,t,x,y,o,N
            c = K(i)
            l = H(i)
            d = H(j)
            f = K(j)

            e = K(a)
            g = H(a)
            h = d + 2
            D = 1 / (c * h * e + f * g + 5)

            m = H(F)
            n = K(F)
            t = c * h * g - f * e

            x = X(40 + 30 * D * (l * h * m - t * n))
            y = X(12 + 15 * D * (l * h * n + t * m))
            o = X(x + (80 * y))
            N = X(8 * ((f * e - c * d * g) * m - c * d * e - f * g - l * d * n))

            if 22>y and y>0 and 80>x and x>0 and D>z[o+1] then
                z[o+1] = D
                if N>0 then
                    b[o+1] = string.sub(".,-~:;=!*#$@",N+1,N+1)
                else
                    b[o+1] = '.'
                end
            end
        end
    end

    -- print
	shell.run("clear")
    for l=1,1760 do
        if l%80 ~= 0 then
            io.write(b[l])
        else
            print()
        end
    end
    
    -- increments
    a=a+0.04
    F=F+0.02
end
