# frozen_string_literal: true
module EDM
  module Rights
    extend ActiveSupport::Concern

    EDM_RIGHTS_PATTERNS = {
      cc0: %r{http://creativecommons.org/(licenses/)?publicdomain/zero},
      cc_by: %r{http://creativecommons.org/licenses/by/},
      cc_by_nc: %r{http://creativecommons.org/licenses/by-nc/},
      cc_by_nc_nd: %r{http://creativecommons.org/licenses/by-nc-nd},
      cc_by_nc_sa: %r{http://creativecommons.org/licenses/by-nc-sa},
      cc_by_nd: %r{http://creativecommons.org/licenses/by-nd},
      cc_by_sa: %r{http://creativecommons.org/licenses/by-sa},
      out_of_copyright_non_commercial: %r{http://www.europeana.eu/rights/out-of-copyright-non-commercial},
      rrfa: %r{http://www.europeana.eu/rights/rr-f},
      rrpa: %r{http://www.europeana.eu/rights/rr-p},
      rrra: %r{http://www.europeana.eu/rights/rr-r/},
      pdm: %r{http://creativecommons.org/publicdomain/mark},
      ucs: %r{http://www.europeana.eu/rights/unknown},
      orphan_work: %r{http://www.europeana.eu/rights/test-orphan}
    }.freeze

    class_methods do
      def edm_rights_label(rights)
        i18n_key = EDM_RIGHTS_PATTERNS.detect { |_k, v| rights =~ v }
        return rights if i18n_key.nil?
        I18n.t(i18n_key.first.to_s.tr('_', '-'), scope: 'copyright')
      end
    end

    def edm_rights_label
      self.class.edm_rights_label(edm_rights)
    end
  end
end
