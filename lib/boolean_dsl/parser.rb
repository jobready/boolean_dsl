class BooleanDsl::Parser < Parslet::Parser
  # Spaces
  rule(:space) { match('\s').repeat(1) }
  rule(:space?) { space.maybe }

  # Literals
  rule(:decimal) do
    (match('[0-9]').repeat(1) >> str(".") >> match('[0-9]').repeat(1)).as(:decimal) >> space?
  end

  rule(:integer) { match('[0-9]').repeat(1).as(:integer) >> space? }

  rule(:string_content) { (str("'").absent? >> any).repeat }
  rule(:string) { str("'") >> string_content.as(:string) >> str("'") >> space? }

  rule(:attribute) do
    (match('[A-Za-z_]') >> match('[A-Za-z_0-9]').repeat >> str('?').maybe).as(:attribute) >> space?
  end

  # Negation
  rule(:negation) { str('!') >> attribute.as(:negation) }

  # Elements
  rule(:element) { negation | decimal | integer | string | attribute }

  # Booleans are rules that will evaluate to a true or false result
  rule(:boolean) { value_comparison | negation | attribute }
  rule(:boolean_sub) { parens | boolean }

  # Operators (Comparison)
  rule(:comparison_operator) do
    (str('==') | str('!=') | str('<=') | str('>=') | str('<') | str('>')).as(:comparison_operator) >> space?
  end
  rule(:value_comparison) { element.as(:left) >> comparison_operator >> element.as(:right) >> space? }

  # Operators (Boolean)
  rule(:boolean_operator) { (str('and') | str('or')).as(:boolean_operator) >> space? }
  rule(:boolean_comparison) { boolean_sub.as(:left) >> boolean_operator >> expression.as(:right) >> space? }

  rule(:parens) { str('(') >> expression.maybe.as(:expression) >> space? >> str(')') >> space? }

  rule(:expression) { boolean_comparison | parens | value_comparison | element }
  root(:expression)
end

