<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class VendorProduk extends Model
{
    use HasFactory;

    protected $table = 'msvendorproduk';
    protected $fillable = [
        'id',
        'idVendor',
        'idProduct',
        'catatan',
        'fgActive',
        'createdBy',
        'createdDate',
    ];
}
