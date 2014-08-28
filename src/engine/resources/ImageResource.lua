local rosa = require("__rosa")

local ImageResource = rosa.types.Resource:extends()

ImageResource.class_name = "ImageResource"
ImageResource.type = "image"
ImageResource.extensions = {"bmp", "png", "jpg", "jpeg"}

function ImageResource:createEmpty()
    error("It's not possible to create an Image without any data. Create it with {width, height} instead")
    self.super.createEmpty(self)
end
    
function ImageResource:create(data)
    self.super.create(self, data)
    
    local image_data = love.image.newImageData(data[1], data[2])
    
    self.data = love.graphics.newImage(image_data)
end

function ImageResource:fromFile(filename)
    self.super.fromFile(self, filename)
    
    self.data = love.graphics.newImage(filename)
end

function ImageResource:fromData(source, data)
    self.super.fromData(self, source, data)
    
    local file_data = love.filesystem.newFileData(data, source)
    local image_data = love.image.newImageData(file_data)
    local image = love.graphics.newImage(image_data)
    
    self.data = image
end

rosa.resman.registerResourceClass(ImageResource)

return ImageResource