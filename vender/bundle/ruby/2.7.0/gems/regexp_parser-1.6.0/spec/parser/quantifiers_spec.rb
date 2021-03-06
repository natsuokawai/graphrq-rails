require 'spec_helper'

RSpec.describe('Quantifier parsing') do
  RSpec.shared_examples 'quantifier' do |pattern, text, mode, token, min, max|
    it "parses the quantifier in #{pattern} as #{mode} #{token}" do
      root = RP.parse(pattern, '*')
      exp = root[0]

      expect(exp).to be_quantified
      expect(exp.quantifier.token).to eq token
      expect(exp.quantifier.min).to eq min
      expect(exp.quantifier.max).to eq max
      expect(exp.quantifier.mode).to eq mode
    end
  end

  include_examples 'quantifier', /a?b/,      '?',      :greedy,     :zero_or_one,  0, 1
  include_examples 'quantifier', /a??b/,     '??',     :reluctant,  :zero_or_one,  0, 1
  include_examples 'quantifier', /a?+b/,     '?+',     :possessive, :zero_or_one,  0, 1
  include_examples 'quantifier', /a*b/,      '*',      :greedy,     :zero_or_more, 0, -1
  include_examples 'quantifier', /a*?b/,     '*?',     :reluctant,  :zero_or_more, 0, -1
  include_examples 'quantifier', /a*+b/,     '*+',     :possessive, :zero_or_more, 0, -1
  include_examples 'quantifier', /a+b/,      '+',      :greedy,     :one_or_more,  1, -1
  include_examples 'quantifier', /a+?b/,     '+?',     :reluctant,  :one_or_more,  1, -1
  include_examples 'quantifier', /a++b/,     '++',     :possessive, :one_or_more,  1, -1
  include_examples 'quantifier', /a{2,4}b/,  '{2,4}',  :greedy,     :interval,     2, 4
  include_examples 'quantifier', /a{2,4}?b/, '{2,4}?', :reluctant,  :interval,     2, 4
  include_examples 'quantifier', /a{2,4}+b/, '{2,4}+', :possessive, :interval,     2, 4
  include_examples 'quantifier', /a{2,}b/,   '{2,}',   :greedy,     :interval,     2, -1
  include_examples 'quantifier', /a{2,}?b/,  '{2,}?',  :reluctant,  :interval,     2, -1
  include_examples 'quantifier', /a{2,}+b/,  '{2,}+',  :possessive, :interval,     2, -1
  include_examples 'quantifier', /a{,3}b/,   '{,3}',   :greedy,     :interval,     0, 3
  include_examples 'quantifier', /a{,3}?b/,  '{,3}?',  :reluctant,  :interval,     0, 3
  include_examples 'quantifier', /a{,3}+b/,  '{,3}+',  :possessive, :interval,     0, 3
  include_examples 'quantifier', /a{4}b/,    '{4}',    :greedy,     :interval,     4, 4
  include_examples 'quantifier', /a{4}?b/,   '{4}?',   :reluctant,  :interval,     4, 4
  include_examples 'quantifier', /a{4}+b/,   '{4}+',   :possessive, :interval,     4, 4

  specify('mode-checking methods') do
    exp = RP.parse(/a??/).first

    expect(exp).to be_reluctant
    expect(exp).to be_lazy
    expect(exp).not_to be_greedy
    expect(exp).not_to be_possessive
    expect(exp.quantifier).to be_reluctant
    expect(exp.quantifier).to be_lazy
    expect(exp.quantifier).not_to be_greedy
    expect(exp.quantifier).not_to be_possessive
  end
end
