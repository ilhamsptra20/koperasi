<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Produk extends Model
{
    use HasFactory;

    protected $table = 'msproduk';

    protected $fillable = [
        'kodeProduk',
        'nama',
        'jenisProduk',
        'sku',
        'produkDesc',
        'haveExpired',
        'satuan',
        'qtyBalance',
        'haveChild',
        'qtyChild',
        'catatan',
        'fgActive',
        'createdBy',
        'createdDate',
        'modifiedBy',
        'modifiedDate'
    ];
}
