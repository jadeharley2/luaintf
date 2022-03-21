

sizelist = {
    [0.0625/16]="minuscule",[0.0625/8]="minuscule",[0.0625/4]="minuscule",[0.0625/2]="minuscule",
    
    [0.0625]="minuscule",[0.125]="miniature",[0.25]="tiny",[0.5]="small",
    [1]="normal",
    [2]="large",[4]="big",[8]="huge",[16]="gigantic",

    [32]="gigantic",[64]="gigantic",[128]="gigantic",[256]="gigantic",
}
thing.size = 1
function thing:textsize()
    return sizelist[self.size]
end
function thing:relative_size(target)
    return target.size/self.size
end
function thing:relative_textsize(target)
    if target then
        return sizelist[target.size/self.size]
    else
        return sizelist[1/self.size]
    end
end