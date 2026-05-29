
# Reservoir Simulation Import from binary ECLIPSE files with MRST

## [`import_eclipse`](./import_eclipse.m) function

Requires [MRST](https://github.com/SINTEF-AppliedCompSci/MRST.git) installed with
`deckformat` module enabled:

```matlab
mrstModule('add','deckformat');
```

## Import MRST rock properties using fine-to-coarse mapping

`import_from_mapping_*.m` functions

- [`ijk`](./import_from_mapping_ijk.m): from Cartesian subscripts
- [`linear`](./import_from_mapping_linear.m): from linear coarse-grid indices
