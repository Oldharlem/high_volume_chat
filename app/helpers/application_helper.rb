module ApplicationHelper
  def flash_class(type)
    base_classes = "shadow-lg"
    
    case type.to_sym
    when :notice, :success
      "#{base_classes} bg-green-100 border border-green-400 text-green-700"
    when :alert, :error
      "#{base_classes} bg-red-100 border border-red-400 text-red-700"
    else
      "#{base_classes} bg-blue-100 border border-blue-400 text-blue-700"
    end
  end
end
