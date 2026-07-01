function appendix()
    if FORMAT == "typst" then
        return pandoc.RawBlock('typst', '#show: appendix')
    end
    return pandoc.Para({})
end

