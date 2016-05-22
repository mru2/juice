require 'hashie'

module MetaField

  def meta
    @_meta ||= Hashie::Mash.new(super)
  end

  def method_missing(name)
    super unless meta.respond_to?(name)
    meta.send(name)
  end

end
