gems=0

function addGems(d,gap,x,dx,num)
    for i=1,num do
        local newx=(x+dx*(i-1))
        if newx>1 then 
            newx=1-(newx%1)
        end
        if newx<-1 then
            newx=-newx%-1
        end

        add(obs,{
            d=d+i*gap,
            x=newx,
            sprx=1*8, 
            spry=0*8,
            w=1,
            h=1,
            scalex=3,
            scaley=3,
            ax=0.5,
            type="gem",
            collide=true,
            keep=true
        })
        gems+=1
    end
end

