/* ruby_tclink.c - Library code for the TCLink client API.
 *
 * TCLink Copyright (c) 2007 TrustCommerce.
 * http://www.trustcommerce.com
 * developer@trustcommerce.com
 * (949) 387-3747
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

#include <ruby.h>
#include "tclink.h"

static VALUE
tclink_getversion(VALUE obj) {
	return rb_str_new2(TCLINK_VERSION);
}

static VALUE
tclink_send(VALUE obj, VALUE params) {
	TCLinkHandle handle;
	char buf[4096];
	VALUE input_keys, input_key, input_value, result;
	char *result_key, *result_value, *next_result_key;
	int input_keys_count;
	int i = 0;

	handle = TCLinkCreate();

	/* grab the Ruby hash and stuff each parameter set into TCLink */
	input_keys = rb_funcall(params, rb_intern("keys"), 0, 0);
	input_keys_count = FIX2INT(rb_funcall(input_keys, rb_intern("length"),
                                   0, 0));

	for (i = 0; i < input_keys_count; i++) {
		input_key = rb_funcall(input_keys, rb_intern("[]"), 1,
                                       INT2FIX(i));
		input_value = rb_hash_aref(params, input_key);
		TCLinkPushParam(handle, RSTRING(StringValue(input_key))->ptr,
                                RSTRING(StringValue(input_value))->ptr);
	}

	/* send the transaction */
	TCLinkSend(handle);

	/* pull out the returned parameters and put them in a Ruby hash */
	TCLinkGetEntireResponse(handle, buf, sizeof(buf));

	result = rb_hash_new();
	result_key = result_value = buf;
	while (result_key && (result_value = strchr(result_key, '='))) {
		*result_value++ = 0;
		next_result_key = strchr(result_value, '\n');
		if (next_result_key) *next_result_key++ = 0;
		rb_hash_aset(result, rb_str_new2(result_key),
                             rb_str_new2(result_value));
		result_key = next_result_key;
	}

	TCLinkDestroy(handle);
	
	/* return the results hash */
	return result;
}

void
Init_tclink() {
	VALUE tclink = rb_define_module("TCLink");

	rb_define_module_function(tclink, "getVersion", tclink_getversion, 0);
	rb_define_module_function(tclink, "send", tclink_send, 1);
}
