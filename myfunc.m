function obj = myfunc(w, AA, b) 
    obj = norm(AA.'*w-b);
    return 
end 