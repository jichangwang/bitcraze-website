module Jekyll
  module GettingStarted
    #
    # Use these tags on gettings started pages
    #

    # Use this tag to create an intro section
    #
    # ; is used as separator
    #
    # The optional id is used if given, otherwise an id is created
    #
    # Examples:
    # {% gs_intro My title %}
    # Some content (supports markdown)
    # {% gs_intro %}
    #
    # {% gs_intro My title; optional id %}
    # Some content (supports markdown)
    # {% gs_intro %}

    class Intro < Liquid::Block
      @@id = 1

      def initialize(tag_name, text, tokens)
        super
        @params = split_strip(text, ';')
      end

      def render(context)
        markup = markdownify(super, context)

        if (@params.length > 1)
          full_id = @params[1]
        else
          full_id = 'intro' + @@id.to_s
          @@id += 1
        end

        '<div class="plm-content-intro-text"><h2 id="%1$s">%2$s</h2>%3$s</div>' % [full_id, @params[0], markup]
      end

      def markdownify(md, context)
        site = context.registers[:site]
        converter = site.find_converter_instance(Jekyll::Converters::Markdown)
        converter.convert(md)
      end

      def split_strip(str, token)
        parts = str.split(token)
        parts.map {|part| part.strip}
      end

      def self.reset_id_counter()
        @@id = 1
      end
    end


    # Use this tag to create an info step section
    #
    # Example:
    # {% gs_step My title %}
    # Some content (supports markdown)
    # {% gs_step %}

    class Step < Liquid::Block
      @@id = 1

      def initialize(tag_name, text, tokens)
        super
        @text = text
      end

      def render(context)
        markup = markdownify(super, context)

        result = '<div class="plm-content-info-step"><h3 id="infostep%1$i">%2$s</h3>%3$s</div>' % [@@id, @text.strip, markup]
        @@id += 1

        result
      end

      def markdownify(md, context)
        site = context.registers[:site]
        converter = site.find_converter_instance(Jekyll::Converters::Markdown)
        converter.convert(md)
      end

      def self.reset_id_counter()
        @@id = 1
      end
    end

  end
end

Liquid::Template.register_tag('gs_intro', Jekyll::GettingStarted::Intro)
Liquid::Template.register_tag('gs_step', Jekyll::GettingStarted::Step)
