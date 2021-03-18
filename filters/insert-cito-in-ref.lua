local List = require 'pandoc.List'
local utils = require 'pandoc.utils'
local citation_properties

local function meta_citation_properties (meta)
  citation_properties = meta.citation_properties
end

local function cito_properties(cite_id)
  local props = citation_properties[cite_id]
  if not props then return {} end

  return List(props):map(
    function (x)
      return pandoc.Strong{
        pandoc.Space(), pandoc.Str '[cito:',
        pandoc.Str(utils.stringify(x)),
        pandoc.Str ']'
      }
    end
  )
end

local function add_cito (div)
  if div.classes:includes 'csl-entry' and div.content[1].t == 'Para' then
    local cite_id = div.identifier:match 'ref%-(.*)'
    local para = div.content[1]
    para.content:extend(cito_properties(cite_id))
    div.content = {para}
  end
  return div
end

return {
  {Meta = meta_citation_properties},
  {Div = add_cito},
}