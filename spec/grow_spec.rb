
#
# spec'ing h.js
#
# Sat Jan 28 15:46:46 JST 2017
#

require 'spec_helpers.rb'


describe 'H' do

  describe '.grow' do

    it 'grows trees' do

      html = evaluate(%{
        return H.grow(function() {

          div('toto');

        }).outerHTML;
      })

      expect(html).to eqh(%{ <div>toto</div> })
    end

    it 'grows trees with ids and classes' do

      html = evaluate(%{
        return H.grow(function() {

          div('#nada.surf', 'toto', '.hell');

        }).outerHTML;
      })

      expect(html).to eqh(%{ <div id="nada" class="surf hell">toto</div> })
    end

    it 'grows trees with subtrees' do

      html = evaluate(%{
        return H.grow(function() {

          div('#nada.surf',
            span('.a', 'alpha'),
            'toto',
            span('.b', 'bravo'));

        }).outerHTML;
      })

      expect(
        html
      ).to eqh(%{
        <div id="nada" class="surf">
          <span class="a">alpha</span>
          toto
          <span class="b">bravo</span>
        </div>
      })
    end

    it 'skips subtrees when `false`' do

      html = evaluate(%{
        return H.grow(function() {

          div('#nada.surf',
            span('.a', 'alpha'),
            span('.b', 'bravo'),
            div('.c',
              false,
              span('.d', 'delta'),
              span('.e', 'echo')))

        }).outerHTML;
      })

      expect(
        html
      ).to eqh(%{
        <div id="nada" class="surf">
          <span class="a">alpha</span>
          <span class="b">bravo</span>
        </div>
      })
    end

    it 'nest correctly' do  # e.innerHTML !== undefined

      html = evaluate(%{
        return H.grow(function() {

          div(span(''));

        }).outerHTML;
      })

      expect(html).to eqh(%{ <div><span></span></div> })
    end
  end

  describe '.makeTemplate' do

    it 'returns a templating function' do

      html = evaluate(%{
        var template = H.makeTemplate(function(h) {
          return div('#id', h.id, { style: 'display: inline-block;' });
        });
        return template({ id: 123 }).outerHTML;
      })

      expect(
        html
      ).to eqh(%{
        <div id="id" style="display: inline-block;">123</div>
      })
    end
  end
end

