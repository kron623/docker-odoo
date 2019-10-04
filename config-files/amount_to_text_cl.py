# -*- coding: utf-8 -*-
##############################################################################
#    
#    OpenERP, Open Source Management Solution
#    Copyright (C) 2004-2009 Tiny SPRL (<http://tiny.be>).
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as
#    published by the Free Software Foundation, either version 3 of the
#    License, or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.     
#
##############################################################################

import logging
from translate import _

_logger = logging.getLogger(__name__)

#-------------------------------------------------------------
#SPANISH CHILE
#-------------------------------------------------------------
def convertNumber(n):
	UNIDADES = ('','UNO ','DOS ','TRES ','CUATRO ','CINCO ','SEIS ','SIETE ','OCHO ','NUEVE ','DIEZ ',
			'ONCE ','DOCE ','TRECE ','CATORCE ','QUINCE ','DIECISEIS ','DIECISIETE ','DIECIOCHO ','DIECINUEVE ','VEINTE ')
	DECENAS = ('VENTI','TREINTA ','CUARENTA ','CINCUENTA ','SESENTA ','SETENTA ','OCHENTA ','NOVENTA ','CIEN ')
	CENTENAS = ('CIENTO ','DOSCIENTOS ','TRESCIENTOS ','CUATROCIENTOS ',
			'QUINIENTOS ','SEISCIENTOS ','SETECIENTOS ','OCHOCIENTOS ','NOVECIENTOS ')

	output = ''
	if(n == '100'):
		output = "CIEN "
	elif(n[0] != '0'):
		output = CENTENAS[int(n[0])-1]
	k = int(n[1:])
	if(k <= 20):
		output += UNIDADES[k]
	else:
		if((k > 30) & (n[2] != '0')):
			output += '%sY %s' % (DECENAS[int(n[1])-2], UNIDADES[int(n[2])])
		else:
			output += '%s%s' % (DECENAS[int(n[1])-2], UNIDADES[int(n[2])])
	return output

def amount_to_text_cl(number_in, currency):
	converted = ''
	if type(number_in) != 'str':
		number = str(round(number_in,2))
	else:
		number = number_in
	number_str=number
	try:
		number_int, number_dec = number_str.split(".")
	except ValueError:
		number_int = number_str
		number_dec = ""
	number_str = number_int.zfill(9)
	millones = number_str[:3]
	miles = number_str[3:6]
	cientos = number_str[6:]
	if(millones):
		if(millones == '001'):
			converted += 'UN MILLON '
		elif(int(millones) > 0):
			converted += '%sMILLONES ' % convertNumber(millones)
	if(miles):
		if(miles == '001'):
			converted += 'MIL '
		elif(int(miles) > 0):
			converted += '%sMIL ' % convertNumber(miles)
        if(cientos):
		if(cientos == '001'):
			converted += 'UN '
		elif(int(cientos) > 0):
			converted += '%s ' % convertNumber(cientos)
	converted += currency+'.'
	return converted

#-------------------------------------------------------------
# Generic functions
#-------------------------------------------------------------

_translate_funcs = {'es_cl' : amount_to_text_cl}
    
def amount_to_text(nbr, lang='es_cl', currency='PESOS'):
	if not _translate_funcs.has_key(lang):
		netsvc.Logger().notifyChannel("amount_to_text",netsvc.LOG_INFO, "WARNING: no translation function found for lang: '%s'" % (lang,))
		lang = 'es_cl'
	return _translate_funcs[lang](abs(nbr), currency)

if __name__=='__main__':
    from sys import argv
    
    lang = 'es_cl'
    if len(argv) < 2:
        for i in range(1,200):
            print i, ">>", amount_to_text_cl(i, lang)
        for i in range(200,999999,139):
            print i, ">>", amount_to_text_cl(i, lang)
    else:
        print amount_to_text_cl(int(argv[1]), lang)

