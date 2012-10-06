module ActionView::Helpers
  class FormBuilder
  
    def globalize_fields_for_locale(locale, *args, &proc)
      raise ArgumentError, "Missing block" unless block_given?
      @index = @index ? @index + 1 : 1
      object_name = "#{@object_name}[translations_attributes][#{@index}]"
      object = @object.translations.find_by_locale(locale.to_s) || @object.translations.new(:locale => locale)
      @template.concat(@template.hidden_field_tag("#{object_name}[id]", object.id)) unless object.new_record?
      @template.concat(@template.hidden_field_tag("#{object_name}[locale]", locale))
      if @template.respond_to? :simple_fields_for
        @template.concat @template.simple_fields_for(object_name, object, *args, &proc)
      else
        @template.concat @template.fields_for(object_name, object, *args, &proc)
      end
    end
  
    alias_method :globalize_fields_for_locale, :globalize_fields_for_locales
    
    def globalize_fields_for_locales(locales = [], *args, &proc)
      locales.each do |locale|
        super(locale, *args, &proc)
      end
    end
    
  end
end