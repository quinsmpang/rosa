ImageResource = Resource:extends()

ImageResource.type = "image"
ImageResource.extensions = {"bmp", "png", "jpg", "jpeg"}

function ImageResource:createEmpty()
    error("It's not possible to create an Image without any data. Create it with {width, height} instead")
    Resource.createEmpty(self)
end
    
function ImageResource:create(data)
    Resource.create(self, data)
    
    local image_data = love.image.newImageData(data[1], data[2])
    
    self.resource = love.graphics.newImage(image_data)
end

function ImageResource:fromFile(filename)
    Resource.fromFile(self, filename)
    
    self.resource = love.graphics.newImage(filename)
end

function ImageResource:fromData(source, data)
    Resource.fromData(self, source, data)
    
    local file_data = love.filesystem.newFileData(data, source)
    local image_data = love.image.newImageData(file_data)
    local image = love.graphics.newImage(image_data)
    
    self.resource = image
end

resman.registerResourceClass(ImageResource)