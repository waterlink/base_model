module BaseModel
  class Model
    attr_accessor :id

    class << self
      attr_accessor :collection

      def count
        collection.count
      end

      def collection
        @collection ||= []
      end

      def find(id)
        collection.select { |e| e.id == id }.first
      end

      def all
        collection
      end

      def destroy_all
        self.collection = []
      end
    end

    def id
      @id ||= object_id
    end

    def initialize(attributes={})
      super()
      attributes.each do |key, value|
        self.send :"#{key}=", value
      end
    end

    def save
      self.class.collection << self unless self.class.find(self.id)
    end
  end
end
