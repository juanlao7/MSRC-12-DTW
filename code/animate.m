function animate(X, save)
    T = size(X, 1);
    filename = 'temp.gif';
    delay = 1/30;

    f = figure;
    h = axes;
    
    for ti = 1:T
        skel_vis(X, ti, h);
        drawnow;
        pause(delay);

        if save
            frame = getframe(1);
            im = frame2im(frame);
            [imind,cm] = rgb2ind(im, 256);

            if ti == 1
                imwrite(imind,cm,filename, 'gif', 'DelayTime', delay, 'Loopcount', inf);
            else
                imwrite(imind,cm,filename, 'gif', 'WriteMode', 'append', 'DelayTime', delay);
            end
        end

        cla;
    end
    
    delete(f);
end

