=begin

literal = [A-z0-9_]+
attribute_name = {literal}
method_name = {attribute_name}[?]?
expression_element = {literal}|{attribute_name}|{method_name}
comparison_operator = =|<|<=|>|>=|!=
expression_sub = {method_name}|{expression_element}{comparison_operator}{expression_element}
boolean_operator = and|or
expression = {expression_sub}|({expression_sub}){boolean_operator}{expression}

=end
class BooleanDsl::Parser < Parslet::Parser
  # Spaces
  rule(:space) { match('\s').repeat(1) }
  rule(:space?) { space.maybe }

  # Literals
  rule(:integer) { match('[0-9]').repeat(1).as(:integer) >> space? }

  rule(:string_content) { (str("'").absent? >> any).repeat }
  rule(:string) { str("'") >> string_content.as(:string) >> str("'") >> space? }

  rule(:attribute) { match('[A-Za-z_]').repeat.as(:attribute) }

  # Elements
  rule(:element) { integer | string | attribute }

  # Operators (Comparison)
  rule(:comparison_operator) do
    (str('==') | str('!=') | str('<') | str('<=') | str('>') | str('>=')).as(:comparison_operator) >> space?
  end
  rule(:comparison) { element.as(:left) >> comparison_operator >> element.as(:right) >> space? }



  rule(:expression) { comparison | element }

  root(:expression)
end

