-- {"id":1842947661,"ver":"1.0.0","libVer":"1.0.0","author":"pirateaba"}

local baseURL = "https://wanderinginn.com"

local function shrinkURL(url, t)
    return url:gsub("^.-wanderinginn%.com", "")
end

local function expandURL(url, t)
    if url:sub(1, 4) == "http" then
        return url
    end
    if url:sub(1, 1) ~= "/" then
        url = "/" .. url
    end
    return baseURL .. url
end

return {
    id = 1842947661,
    name = "The Wandering Inn",
    baseURL = baseURL,
    imageURL = "https://wanderinginn.com/wp-content/uploads/2016/11/erin-150x150.png",
    chapterType = ChapterType.HTML,

    listings = {
        Listing("Chapters", false, function()
            return {
                Novel {
                    title = "The Wandering Inn",
                    link = "/table-of-contents/",
                    imageURL = "https://wanderinginn.com/wp-content/uploads/2026/03/3.png"
                }
            }
        end)
    },

    shrinkURL = shrinkURL,
    expandURL = expandURL,

    parseNovel = function(url, loadChapters)
        local doc = GETDocument(expandURL(url, KEY_NOVEL_URL))

        local novel = NovelInfo {
            title = "The Wandering Inn",
            imageURL = "https://wanderinginn.com/wp-content/uploads/2026/03/3.png",
            description = "An old inn by the road. A girl who fell into another world. A story that won't end.\n\nThe Wandering Inn is a web serial by pirateaba.",
            authors = { "pirateaba" },
            genres = { "Fantasy", "Adventure" },
            tags = { "LitRPG", "Isekai", "Female Protagonist", "Web Serial" },
            status = NovelStatus(3)
        }

        if loadChapters then
            local chapters = {}
            -- Select all anchor tags and filter to chapter URLs (date-based paths)
            local links = doc:select("a")
            for i = 0, links:size() - 1 do
                local a = links:get(i)
                local href = a:attr("abs:href")
                local title = a:text()
                -- Match URLs with date-based paths: /YYYY/MM/DD/slug/
                if href ~= nil and href ~= "" and title ~= nil and title ~= ""
                    and href:match("wanderinginn%.com/%d%d%d%d/%d%d/%d%d/") then
                    chapters[#chapters + 1] = NovelChapter {
                        order = #chapters + 1,
                        title = title,
                        link = shrinkURL(href)
                    }
                end
            end
            novel:setChapters(AsList(chapters))
        end

        return novel
    end,

    getPassage = function(url)
        local doc = GETDocument(expandURL(url, KEY_CHAPTER_URL))
        -- WordPress stores post content in .entry-content
        local content = doc:selectFirst(".entry-content")
        if content == nil then
            content = doc:selectFirst("article")
        end
        -- Remove comment sections and cookie banners
        local toRemove = content:select("#wpdcom, .comments-area, .cookie-banner")
        for i = 0, toRemove:size() - 1 do
            toRemove:get(i):remove()
        end
        return pageOfElem(content, false)
    end,

    isSearchIncrementing = false,
    search = function(data) return {} end,
    searchFilters = {}
}
