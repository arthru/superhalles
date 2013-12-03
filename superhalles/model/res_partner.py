from openerp.osv import fields, orm


class res_partner(orm.Model):
    _inherit = 'res.partner'
    
    _columns = {
        'is_nice': fields.boolean('Is nice'),
    }

    def method(self, cr, uid, ids):
        print 'foo'
